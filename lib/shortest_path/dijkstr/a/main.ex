defmodule ShortestPath.Dijkstr.A.Main do
  alias :mnesia, as: Mnesia
  @support_in "test/support/in"

  def init() do
    Mnesia.create_schema([node()])
    Mnesia.start()

    case Mnesia.create_table(GraphStatus, attributes: [:gid, :n, :m, :num_entry]) do
      {:atomic, :ok} -> :ok
      {:aborted, {:already_exists, GraphStatus}} -> :ok
      {:aborted, reason} -> {:error, reason}
    end
    |> case do
      :ok ->
        case Mnesia.create_table(GraphEntry, attributes: [:entry_id, :left_entry_id, :right_entry_id, :vertex, :weight]) do
          {:atomic, :ok} -> :ok
          {:aborted, {:already_exists, GraphEntry}} -> :ok
          {:aborted, reason} -> {:error, reason}
        end
        |> case do
          :ok ->
            case Mnesia.create_table(Graph, attributes: [:vertex_id, :entry_id]) do
              {:atomic, :ok} -> :ok
              {:aborted, {:already_exists, Graph}} -> :ok
              {:aborted, reason} -> {:error, reason}
            end

          {:error, reason} -> {:error, reason}
        end

      {:error, reason} -> {:error, reason}
    end
  end

  def finish() do
    Mnesia.clear_table(Graph)
    Mnesia.clear_table(GraphEntry)
    Mnesia.clear_table(GraphStatus)
    Mnesia.delete_table(Graph)
    Mnesia.delete_table(GraphEntry)
    Mnesia.delete_table(GraphStatus)
    Mnesia.stop()
  end

  def main(file) do
    stream =
      Path.join(@support_in, file)
      |> File.stream!([:read], :line)

    [n, m] =
      stream
      |> Enum.take(1)
      |> hd()
      |> String.trim()
      |> String.split(" ")
      |> Enum.map(&String.to_integer/1)

    {:atomic, _ } =
      Mnesia.transaction(fn ->
        Mnesia.write({GraphStatus, 0, n, m, 0})
      end)

    # pos =
    #   stream
    #   |> Stream.drop(1)
    #   |> Stream.take(n)
    #   |> Stream.map(& String.trim(&1))
    #   |> Stream.map(& String.split(&1, " "))
    #   |> Stream.map(fn l -> Enum.map(l, &String.to_integer/1) end)
    #   |> Enum.take(n)

    stream
    |> Stream.drop(n + 1)
    |> Stream.take(m)
    |> Stream.map(&String.trim(&1))
    |> Stream.map(&String.split(&1, " "))
    |> Stream.map(fn l -> Enum.map(l, &String.to_integer/1) end)
    |> Stream.map(fn [n1, n2, w] ->
      cond do
        n1 < n2 -> {n1, n2, w}
        n2 < n1 -> {n2, n1, w}
        true -> raise RuntimeError, "Exists edge from a node to the same node."
      end
    end)
    |> Stream.map(fn {n1, n2, w} -> write_graph(n1, n2, w)  end)
    |> Enum.take(m)
  end

  def current_weight(n1, n2) when n1 < n2 do
    {:atomic, w}
      = Mnesia.transaction(fn ->
        [{Graph, ^n1, e}] = Mnesia.read({Graph, n1})
        current_weight_s(e, n2)
      end)

    w
  end

  def current_weight(n1, n2) when n1 > n2 do
    current_weight(n2, n1)
  end

  defp current_weight_s(:end, _target) do
    nil
  end

  defp current_weight_s(e, target) do
    [{GraphEntry, ^e, left, right, n, w}] = Mnesia.read({GraphEntry, e})

    cond do
      n == target -> w
      n < target -> current_weight_s(right, target)
      true -> current_weight_s(left, target)
    end
  end

  def new_entry() do
    {:atomic, [{GraphStatus, 0, _n, _m, e_num}]}
      = Mnesia.transaction(fn ->
        case Mnesia.read({GraphStatus, 0}) do
          [] -> raise RuntimeError, "Fail to fetch GraphStatus"

          [{GraphStatus, 0, n, m, e_num}] ->
            Mnesia.write({GraphStatus, 0, n, m, e_num + 1})
            Mnesia.read({GraphStatus, 0})

          _ -> raise RuntimeError, "Fail to fetch GraphStatus"
        end
      end)

    e_num - 1
  end

  def write_graph(n1, n2, w) do
    Mnesia.transaction(fn ->
      Mnesia.wread({Graph, n1})
      |> case do
        [] ->
          eid = new_entry()
          Mnesia.write({GraphEntry, eid, :end, :end, n2, w})
          Mnesia.write({Graph, n1, eid})

        [{Graph, ^n1, entry}] -> add_entry(entry, n2, w)
        end
    end)
  end

  def add_entry(entry, n, w) do
    Mnesia.transaction(fn ->
      case Mnesia.read({GraphEntry, entry}) do
        [{GraphEntry, ^entry, :end, :end, n1, w1}] ->
          eid = new_entry()
          cond do
            n1 < n ->
              Mnesia.write({GraphEntry, entry, :end, eid, n1, w1})
              Mnesia.write({GraphEntry, eid, :end, :end, n, w})

            n < n1 ->
              Mnesia.write({GraphEntry, entry, eid, :end, n1, w1})
              Mnesia.write({GraphEntry, eid, :end, :end, n, w})

            true ->
              unless w == w1 do
                raise RuntimeError, "n == n1 and w != w1 #{inspect({n, w, w1})}"
              end
          end

        [{GraphEntry, ^entry, left, right, n1, w1}] ->
          cond do
            n1 < n -> add_entry(right, n, w)
            n < n1 -> add_entry(left, n, w)

            true ->
              if w1 == w do
                :ok
              else
                raise RuntimeError, "n == n1 and w != w1 #{inspect({n, w, w1})}"
              end
          end
      end
    end)
  end
end
