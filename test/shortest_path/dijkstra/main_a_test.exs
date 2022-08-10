defmodule ShortestPath.Dijkstra.MainATest do
  use ExUnit.Case
  doctest ShortestPath.Dijkstra.MainA
  alias ShortestPath.Dijkstra.MainA

  test "solve sample_01 by Dijkstra" do
    {n, m, inputs} = ShortestPath.Dijkstr.InputReader.read("sample_01.txt")

    actual =
      MainA.main(n, m, inputs)
      |> ShortestPath.Dijkstr.OutputWriter.puts()

    expected =
      File.read!("test/support/out/sample_01.txt")
      |> String.trim()

    assert actual == expected
  end

end
