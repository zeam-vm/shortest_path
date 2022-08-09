defmodule ShortestPath.DijkstraTest do
  use ExUnit.Case
  doctest ShortestPath.Dijkstra
  alias ShortestPath.Dijkstra

  test "solve case1" do
    [[n, m] | inputs] =
      File.read!("test/support/in/case1.txt")
      |> String.split("\n")
      |> Enum.reject(& &1 == "")
      |> Enum.map(fn s -> String.split(s, " ") |> Enum.map(&String.to_integer/1) end)

    Dijkstra.main(n, m, inputs)
    |> IO.inspect()
  end

end
