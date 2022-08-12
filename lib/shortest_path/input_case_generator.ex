defmodule ShortestPath.InputCaseGenerator do
  @moduledoc """
  A generator of input case for an undirected graph.
  """

  @path "test/support/in"
  @weight_max 1_000
  @size_grid 16

  @doc """
  Generates a file of an input case in `test/support/in`.

  ## Examples

    ```
    iex> :rand.seed(:exsss)
    iex> ShortestPath.InputCaseGenerator.generate("sample_01.txt", 4, 6)
    ```
  """
  def generate(file, n, m, x \\ @size_grid, y \\ @size_grid) do
    generate_s(@path, file, n, m, x, y, true)
  end

  @doc """
  Generates a file of an input case in `Applicatoin.app_dir(:shortest_path, "priv")`.
  """
  def generate_priv(file, n, m, x \\ @size_grid, y \\ @size_grid) do
    path = Application.app_dir(:shortest_path, "priv")
    File.mkdir_p(path)
    generate_s(path, file, n, m, x, y, false)
  end

  defp generate_s(path, file, n, m, x, y, check_exists?) do
    file = Path.join(path, file)

    if check_exists? and File.exists?(file) do
      {:error, "File #{file} has already existed."}
    else
      case File.write(file, new_case(n, m, x, y)) do
        :ok -> {:ok, file}
        {:error, reason} -> {:error, reason}
      end
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
