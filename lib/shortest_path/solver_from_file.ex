defmodule ShortestPath.SolverFromFile do
  @moduledoc """
  Behaviour of a solver from a file.
  """

  @doc """
  Returns a string of the result weights between nodes from an input case file.
  """
  @callback main_p(Path.t(), module()) :: String.t()

  @doc """
  Initializes (hook).
  """
  @callback init() :: :ok | {:error, any()}

  @doc """
  Finalizes (hook).
  """
  @callback finish() :: :ok

  @doc """
  Returns a string of the result weights between nodes from an input case file.
  """
  @spec main_pp(Path.t(), module(), module()) :: String.t()
  def main_pp(file, module, solver_module) do
    Function.capture(solver_module, :main_p, 2).(file, module)
  end

  @doc """
  Initializes.
  """
  @spec call_init(module()) :: :ok | {:error, any()}
  def call_init(module) do
    Function.capture(module, :init, 0).()
  end

  @doc """
  Finalizes.
  """
  @spec call_finish(module()) :: :ok
  def call_finish(module) do
    Function.capture(module, :finish, 0).()
  end
end
