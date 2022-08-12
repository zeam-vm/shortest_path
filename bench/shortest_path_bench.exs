:rand.seed(:exsss, {100, 101, 102})
inputs =
  Stream.unfold(3, fn
    0 -> nil
    n -> {:math.pow(10, n) |> round() , n - 1}
  end)
  |> Enum.reverse()
  |> Enum.map(fn n ->
    1..4
    |> Enum.map(& div(n * (n - 1), 4 * 2) * &1)
    |> Enum.map(fn m -> {n, m} end)
  end)
  |> List.flatten()
  |> Enum.with_index()
  |> Enum.map(fn {{n, m}, i} -> {n, m, "input#{i}.txt"} end)
  |> Stream.map(fn {n, m, file} -> {n, m, ShortestPath.InputCaseGenerator.generate_priv(file, n, m)} end)
  |> Enum.map(fn {n, m, {:ok, file}} -> {"N,M = #{n},#{m}", {n, m, file}} end)
  |> Map.new()

Benchee.run(
  %{
    "Dijkstra.MainA" => fn {_n, _m, file} ->
      pid = spawn(fn ->
        receive do
          {:r_pid, r_pid} ->
            {n, m, i} = ShortestPath.InputReader.read_directly(file)
            ShortestPath.Dijkstra.MainA.main(n, m, i)
            send(r_pid, :ok)
          after 1000 -> :error
        end
      end)

      send(pid, {:r_pid, self()})

      receive do
        :ok -> :ok
      after 2000 ->
        Process.exit(pid, :normal)
      end
    end
  },
  inputs: inputs,
  memory_time: 2
)
