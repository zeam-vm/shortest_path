defmodule ShortestPath.Dijkstra.MainATest do
  use ExUnit.Case
  doctest ShortestPath.Dijkstra.MainA
  alias ShortestPath.Dijkstra.MainA
  @path_in "test/support/in"

  test "solve sample_01 by Dijkstra" do
    actual =
      Path.join(@path_in, "sample_01.txt")
      |> ShortestPath.SolverFromWeightedEdgeList.main_p(MainA)

    expected =
      File.read!("test/support/out/sample_01.txt")
      |> String.trim()

    assert actual == expected
  end

  test "solve sample_02 by Dijkstra" do
    actual =
      Path.join(@path_in, "sample_02.txt")
      |> ShortestPath.SolverFromWeightedEdgeList.main_p(MainA)

    expected =
      File.read!("test/support/out/sample_02.txt")
      |> String.trim()

    assert actual == expected
  end
end
