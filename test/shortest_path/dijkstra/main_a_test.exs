defmodule ShortestPath.Dijkstra.MainATest do
  use ExUnit.Case
  doctest ShortestPath.Dijkstra.MainA
  alias ShortestPath.Dijkstra.MainA

  test "solve sample_01 by Dijkstra" do
    {n, m, inputs} = ShortestPath.InputReader.read("sample_01.txt")

    actual =
      MainA.main(n, m, inputs)
      |> ShortestPath.OutputWriter.puts()

    expected =
      File.read!("test/support/out/sample_01.txt")
      |> String.trim()

    assert actual == expected
  end

  test "solve sample_02 by Dijkstra" do
    {n, m, inputs} = ShortestPath.InputReader.read("sample_01.txt")

    actual =
      MainA.main(n, m, inputs)
      |> ShortestPath.OutputWriter.puts()

    expected =
      File.read!("test/support/out/sample_01.txt")
      |> String.trim()

    assert actual == expected
  end
end
