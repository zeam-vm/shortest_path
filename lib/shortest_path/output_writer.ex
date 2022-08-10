defmodule ShortestPath.OutputWriter do
  @doc """
  Returns a string for IO.puts/2 from the given list of the list that contains all distances between all vertices.
  """
  def puts(outputs) do
    "#{Enum.count(outputs)}\n" <>
      (outputs
       |> Enum.with_index()
       |> Enum.map(fn {ds, i} ->
         ds
         |> Enum.with_index()
         |> Enum.filter(fn {_d, j} -> i < j end)
         |> Enum.map(fn {d, _j} -> d end)
       end)
       |> Enum.map(&Enum.join(&1, " "))
       |> Enum.reject(&(&1 == ""))
       |> Enum.join("\n"))
  end
end
