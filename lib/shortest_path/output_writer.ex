defmodule ShortestPath.OutputWriter do
  def puts(outputs) do
    outputs
    |> Enum.with_index()
    |> Enum.map(fn {ds, i} ->
      ds
      |> Enum.with_index()
      |> Enum.filter(fn {_d, j} -> i < j end)
      |> Enum.map(fn {d, _j} -> d end)
    end)
    |> Enum.map(&Enum.join(&1, " "))
    |> Enum.reject(&(&1 == ""))
    |> Enum.join("\n")
  end
end
