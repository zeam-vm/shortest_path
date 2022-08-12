defmodule ShortestPath.Dijkstra.MainATest do
  use ExUnit.Case
  doctest ShortestPath.Dijkstra.MainA
  alias ShortestPath.Dijkstra.MainA
  @path_in "test/support/in"
  @path_out "test/support/out"

  def test_case(file, module, solver_module) do
    {actual, expected} =
      try do
        ShortestPath.SolverFromFile.call_init(solver_module)

        actual =
          Path.join(@path_in, file)
          |> ShortestPath.SolverFromFile.main_pp(module, solver_module)

        expected =
          Path.join(@path_out, file)
          |> File.read!()
          |> String.trim()

        {actual, expected}
      after
        ShortestPath.SolverFromFile.call_finish(solver_module)
      end

    assert actual == expected
  end

  test "solve sample_01 by Dijkstra" do
    test_case("sample_01.txt", MainA, ShortestPath.SolverFromWeightedEdgeList)
  end

  test "solve sample_02 by Dijkstra" do
    test_case("sample_02.txt", MainA, ShortestPath.SolverFromWeightedEdgeList)
  end
end
