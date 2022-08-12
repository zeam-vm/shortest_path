defmodule ShortestPath.SolverFromWeightedEdgeList do
  @behaviour ShortestPath.SolverFromFile

  @moduledoc """
  Behaviour of a solver from a list of lists of weighted edges.
  """

  @type weighted_edge_list() :: list(list(pos_integer()))
  @type weight_between_nodes_list() :: list(list(pos_integer()))

  @doc """
  Returns a list of lists weights between nodes from a list of lists of weighted edges.
  """
  @callback main(pos_integer(), pos_integer(), weighted_edge_list) :: weight_between_nodes_list

  @doc """
  Returns a string of the result weights between nodes from an input case file.
  """
  @impl true
  @spec main_p(Path.t(), module()) :: String.t()
  def main_p(file, module) do
    {n, m, inputs} = ShortestPath.InputReader.read_directly(file)

    Function.capture(module, :main, 3).(n, m, inputs)
    |> ShortestPath.OutputWriter.puts()
  end
end
