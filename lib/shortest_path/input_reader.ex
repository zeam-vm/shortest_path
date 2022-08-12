defmodule ShortestPath.InputReader do
  @support_in "test/support/in"
  @buffer_size 65536

  @doc """
  Reads a given file and returns a tuple of *N*, *M* and the list of the lists `[Vaj, Vbj, Wj]` in `test/support/in`.
  """
  @spec read(Path.t()) :: {pos_integer(), pos_integer(), ShortestPath.SolverFromWeightedEdgeList.weighted_edge_list()}
  def read(file) do
    read_directly(Path.join(@support_in, file))
  end

  @doc """
  Reads a given file and returns a tuple of *N*, *M* and the list of the lists `[Vaj, Vbj, Wj]` in anywhere in the file system.
  """
  @spec read_directly(Path.t()) :: {pos_integer(), pos_integer(),  ShortestPath.SolverFromWeightedEdgeList.weighted_edge_list()}
  def read_directly(file) do
    stream = File.stream!(file, [read_ahead: @buffer_size], :line)

    [n, m] =
      stream
      |> Enum.take(1)
      |> hd()
      |> String.trim()
      |> String.split(" ")
      |> Enum.map(&String.to_integer/1)

    # pos =
    #   stream
    #   |> Stream.drop(1)
    #   |> Stream.take(n)
    #   |> Stream.map(& String.trim(&1))
    #   |> Stream.map(& String.split(&1, " "))
    #   |> Stream.map(fn l -> Enum.map(l, &String.to_integer/1) end)
    #   |> Enum.take(n)

    input =
      stream
      |> Stream.drop(n + 1)
      |> Stream.take(m)
      |> Stream.map(&String.trim(&1))
      |> Stream.map(&String.split(&1, " "))
      |> Stream.map(fn l -> Enum.map(l, &String.to_integer/1) end)
      |> Enum.take(m)

    {n, m, input}
  end
end
