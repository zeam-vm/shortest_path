defmodule ShortestPath.Dijkstra.MainATest do
  use ExUnit.Case
  doctest ShortestPath.Dijkstra.MainA
  alias ShortestPath.Dijkstra.MainA

  test "solve case1 by Dijkstra" do
    {n, m, inputs} = ShortestPath.Dijkstr.InputReader.read("sample_01.txt")
    outputs = MainA.main(n, m, inputs)

    answer =
      outputs
      |> Enum.map(& Enum.join(&1, " "))
      |> Enum.join("\n")

    assert answer == File.read!("test/support/out/sample_01.txt")
  end

end
