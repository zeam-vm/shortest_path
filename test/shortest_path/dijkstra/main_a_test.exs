defmodule ShortestPath.Dijkstra.MainATest do
  use ExUnit.Case
  doctest ShortestPath.Dijkstra.MainA
  alias ShortestPath.Dijkstra.MainA

  test "solve case1 by Dijkstra" do
    [[n, m] | inputs] =
      File.read!("test/support/in/case1.txt")
      |> String.split("\n")
      |> Enum.reject(& &1 == "")
      |> Enum.map(fn s -> String.split(s, " ") |> Enum.map(&String.to_integer/1) end)

    outputs = MainA.main(n, m, inputs)

    answer =
      outputs
      |> Enum.map(& Enum.join(&1, " "))
      |> Enum.join("\n")

    assert answer == File.read!("test/support/out/case1.txt")
  end

end
