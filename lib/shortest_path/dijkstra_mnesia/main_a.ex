defmodule ShortestPath.DijkstraMnesia.MainA do
  @behaviour ShortestPath.SolverFromFile
  alias :mnesia, as: Mnesia
  @buffer_size 65536
  @inf 1_000_000_000_000

  @impl true
  @spec init() :: :ok | {:error, any()}
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
        case Mnesia.create_table(GraphEntry,
               attributes: [:entry_id, :left_entry_id, :right_entry_id, :vertex, :weight]
             ) do
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

          {:error, reason} ->
            {:error, reason}
        end

      {:error, reason} ->
        {:error, reason}
    end
  end

  @impl true
  @spec finish() :: :ok
  def finish() do
    Mnesia.clear_table(Graph)
    Mnesia.clear_table(GraphEntry)
    Mnesia.clear_table(GraphStatus)
    Mnesia.delete_table(Graph)
    Mnesia.delete_table(GraphEntry)
    Mnesia.delete_table(GraphStatus)
    Mnesia.stop()
    :ok
  end

  @impl true
  @spec main_p(Path.t(), module()) :: String.t()
  def main_p(file, _module) do
    stream = File.stream!(file, [read_ahead: @buffer_size], :line)

    [n, m] =
      stream
      |> Enum.take(1)
      |> hd()
      |> String.trim()
      |> String.split(" ")
      |> Enum.map(&String.to_integer/1)

    {:atomic, _} =
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
      write_graph(n1, n2, w, true)
      write_graph(n2, n1, w, true)
    end)
    |> Enum.take(m)

    for start_node <- 1..n do
      unsearched =
        edges_from(start_node)
        |> Enum.sort(fn n1, n2 ->
          current_weight(start_node, n1) < current_weight(start_node, n2)
        end)

      dijkstra(start_node, unsearched)
    end

    "#{n}\n" <>
      (1..(n - 1)
       |> Enum.map(fn n1 ->
         (n1 + 1)..n
         |> Enum.map(fn n2 ->
           current_weight(n1, n2)
         end)
         |> Enum.join(" ")
       end)
       |> Enum.join("\n"))
  end

  def dijkstra(_start_node, []), do: []

  def dijkstra(start_node, [node | tail]) do
    edges_from(node)
    |> Enum.sort(fn n1, n2 ->
      current_weight(start_node, n1) < current_weight(start_node, n2)
    end)
    |> Enum.map(fn n ->
      w = current_weight(start_node, node) + current_weight(node, n)

      if w < current_weight(start_node, n) do
        write_graph(start_node, n, w, false)
        # ^w = current_weight(start_node, n)
      end
    end)

    dijkstra(start_node, tail)
  end

  def edges_from(n) do
    Mnesia.transaction(fn ->
      [{Graph, ^n, e}] = Mnesia.read({Graph, n})
      edges_from_s([], e)
    end)
    |> case do
      {:atomic, edges} -> edges
    end
  end

  defp edges_from_s(acc, :end), do: acc

  defp edges_from_s(acc, e) do
    [{GraphEntry, ^e, left, right, n, _w}] = Mnesia.read({GraphEntry, e})

    acc = edges_from_s([n | acc], left)
    edges_from_s(acc, right)
  end

  def current_weight(n1, n2) when n1 < n2 do
    Mnesia.transaction(fn ->
      [{Graph, ^n1, e}] = Mnesia.read({Graph, n1})
      current_weight_s(e, n2)
    end)
    |> case do
      {:atomic, nil} -> @inf
      {:atomic, w} -> w
      {:aborted, _} -> @inf
    end
  end

  def current_weight(n1, n2) when n1 > n2 do
    current_weight(n2, n1)
  end

  def current_weight(n, n), do: 0

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
    {:atomic, [{GraphStatus, 0, _n, _m, e_num}]} =
      Mnesia.transaction(fn ->
        case Mnesia.read({GraphStatus, 0}) do
          [] ->
            raise RuntimeError, "Fail to fetch GraphStatus"

          [{GraphStatus, 0, n, m, e_num}] ->
            Mnesia.write({GraphStatus, 0, n, m, e_num + 1})
            Mnesia.read({GraphStatus, 0})

          _ ->
            raise RuntimeError, "Fail to fetch GraphStatus"
        end
      end)

    e_num - 1
  end

  def write_graph(n1, n2, w, raise_if_same_node?) do
    Mnesia.transaction(fn ->
      Mnesia.wread({Graph, n1})
      |> case do
        [] ->
          eid = new_entry()
          Mnesia.write({GraphEntry, eid, :end, :end, n2, w})
          Mnesia.write({Graph, n1, eid})

        [{Graph, ^n1, entry}] ->
          add_entry(entry, n2, w, raise_if_same_node?)
      end
    end)
    |> case do
      {:atomic, _} -> {:atomic, :ok}
    end
  end

  def add_entry(entry, n, w, raise_if_same_node?) do
    Mnesia.transaction(fn ->
      case Mnesia.read({GraphEntry, entry}) do
        [{GraphEntry, ^entry, :end, :end, n1, w1}] ->
          cond do
            n1 < n ->
              eid = new_entry()
              Mnesia.write({GraphEntry, entry, :end, eid, n1, w1})
              Mnesia.write({GraphEntry, eid, :end, :end, n, w})

            n < n1 ->
              eid = new_entry()
              Mnesia.write({GraphEntry, entry, eid, :end, n1, w1})
              Mnesia.write({GraphEntry, eid, :end, :end, n, w})

            true ->
              unless w == w1 do
                if raise_if_same_node? do
                  raise RuntimeError, "n == n1 and w != w1 #{inspect({n, w, w1})}"
                else
                  Mnesia.write({GraphEntry, entry, :end, :end, n, min(w, w1)})
                end
              end
          end

        [{GraphEntry, ^entry, left, right, n1, w1}] ->
          cond do
            n1 < n ->
              add_entry(right, n, w, raise_if_same_node?)

            n < n1 ->
              add_entry(left, n, w, raise_if_same_node?)

            true ->
              if w1 == w do
                :ok
              else
                if raise_if_same_node? do
                  raise RuntimeError, "n == n1 and w != w1 #{inspect({n, w, w1})}"
                else
                  Mnesia.write({GraphEntry, entry, left, right, n1, min(w, w1)})
                end
              end
          end
      end
    end)
  end
end
