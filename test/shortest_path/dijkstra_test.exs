defmodule ShortestPath.DijkstraTest do
  use ExUnit.Case
  doctest ShortestPath.Dijkstra
  alias ShortestPath.Dijkstra

  test "solve case1 by Dijkstra" do
    [[n, m] | inputs] =
      File.read!("test/support/in/case1.txt")
      |> String.split("\n")
      |> Enum.reject(& &1 == "")
      |> Enum.map(fn s -> String.split(s, " ") |> Enum.map(&String.to_integer/1) end)

    outputs = Dijkstra.main(n, m, inputs)

    answer =
      outputs
      |> Enum.map(& Enum.join(&1, " "))
      |> Enum.join("\n")

    assert answer == File.read!("test/support/out/case1.txt")
  end

end
