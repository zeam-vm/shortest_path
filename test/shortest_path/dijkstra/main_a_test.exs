defmodule ShortestPath.Dijkstra.MainATest do
  use ExUnit.Case
  doctest ShortestPath.Dijkstra.MainA
  alias ShortestPath.Dijkstra.MainA

  test "solve case1 by Dijkstra" do
    {n, m, inputs} = ShortestPath.Dijkstr.InputReader.read("sample_01.txt")
    outputs = MainA.main(n, m, inputs)

    actual =
      outputs
      |> Enum.with_index()
      |> Enum.map(fn {ds, i} ->
        ds
        |> Enum.with_index()
        |> Enum.filter(fn {_d, j} -> i < j end)
        |> Enum.map(fn {d, _j} -> d end)
      end)
      |> Enum.map(& Enum.join(&1, " "))
      |> Enum.reject(& &1 == "")
      |> Enum.join("\n")

    expected =
      File.read!("test/support/out/sample_01.txt")
      |> String.trim()

    assert actual == expected
  end

end
