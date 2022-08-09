defmodule ShortestPath.InputCaseGenerator do
  @moduledoc """
  A generator of input case for an undirected graph.
  """

  @path "test/support/in"
  @weight_max 1_000
  @size_grid 16

  @doc """
  Generates a file of an input case.

  ## Examples

    ```
    iex> :rand.seed(:exsss)
    {%{
      bits: 58,
      jump: #Function<3.34006561/1 in :rand.exsplus_jump>,
      next: #Function<0.34006561/1 in :rand.exsss_next>,
      type: :exsss,
      uniform: #Function<1.34006561/1 in :rand.exsss_uniform>,
      uniform_n: #Function<2.34006561/2 in :rand.exsss_uniform>
    }, [159490999984126049 | 263038410355716720]}
    iex> ShortestPath.InputCaseGenerator.generate("sample_01.txt", 4, 6)
    :ok
    ```
  """
  def generate(file, n, m, x \\ @size_grid, y \\ @size_grid) do
    file = Path.join(@path, file)

    if File.exists?(file) do
      {:error, "File #{file} has already existed."}
    else
      File.write(file, new_case(n, m, x, y))
    end
  end

  @doc """
  Generate an input case.

  ## Examples

      iex> :rand.seed(:exsss, {100, 101, 102})
      iex> ShortestPath.InputCaseGenerator.new_case(2, 1)
      "2 1\\n16 0\\n0 16\\n1 2 854"

      iex> :rand.seed(:exsss, {100, 101, 102})
      iex> ShortestPath.InputCaseGenerator.new_case(3, 3)
      "3 3\\n16 0\\n0 32\\n16 0\\n2 3 680\\n1 2 110\\n1 3 439"
  """
  def new_case(n, m, x \\ @size_grid, y \\ @size_grid) do
    ["#{n} #{m}"]
    |> Kernel.++(
      Enum.map(1..n, fn _ ->
        "#{x * (:rand.uniform(n) - 1)} #{y * (:rand.uniform(n) - 1)}"
      end)
    )
    |> Kernel.++(
      for n1 <- 1..n, n2 <- n1..n do
        {n1, n2}
      end
      |> Enum.reject(fn {n1, n2} -> n1 == n2 end)
      |> Enum.map(fn {n1, n2} -> "#{n1} #{n2} #{:rand.uniform(@weight_max)}" end)
      |> Enum.shuffle()
      |> Enum.take(m)
    )
    |> Enum.join("\n")
  end
end
