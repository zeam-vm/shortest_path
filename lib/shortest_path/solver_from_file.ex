defmodule ShortestPath.SolverFromFile do
  @moduledoc """
  Behaviour of a solver from a file.
  """

  @doc """
  Returns a string of the result weights between nodes from an input case file.
  """
  @callback main_p(Path.t(), module()) :: String.t()
end
