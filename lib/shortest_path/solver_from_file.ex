defmodule ShortestPath.SolverFromFile do
  @moduledoc """
  Behaviour of a solver from a file.
  """

  @doc """
  Returns a string of the result weights between nodes from an input case file.
  """
  @callback main_p(Path.t(), module()) :: String.t()

  @doc """
  Returns a string of the result weights between nodes from an input case file.
  """
  @spec main_pp(Path.t(), module(), module()) :: String.t()
  def main_pp(file, module, solver_module) do
    Function.capture(solver_module, :main_p, 2).(file, module)
  end
end
