defmodule ShortestPath.SolverFromWeightedEdgeList do
  @type weighted_edge_list :: list(list(pos_integer()))
  @type weight_between_nodes_list :: list(list(pos_integer()))

  @callback main(pos_integer(), pos_integer(), weighted_edge_list) :: weight_between_nodes_list
end
