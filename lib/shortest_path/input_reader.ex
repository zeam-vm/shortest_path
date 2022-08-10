defmodule ShortestPath.Dijkstra.InputReader do
  @support_in "test/support/in"

  def read(file) do
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
