defmodule ShortestPath.SolverFromWeightedEdgeList do
  @type weighted_edge_list :: list(list(pos_integer()))
  @type weight_between_nodes_list :: list(list(pos_integer()))

  @callback main(pos_integer(), pos_integer(), weighted_edge_list) :: weight_between_nodes_list

  @spec main_p(Path.t(), module()) :: String.t()
  def main_p(file, module) do
    {n, m, inputs} = ShortestPath.InputReader.read_directly(file)

    Function.capture(module, :main, 3).(n, m, inputs)
    |> ShortestPath.OutputWriter.puts()
  end
end
