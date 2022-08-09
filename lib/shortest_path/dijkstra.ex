defmodule ShortestPath.Dijkstra do
  @inf 1000_000_000

  @doc """
  """
  def main(n, m, vicinities) do
    # 各頂点
    node_map =
      vicinities
      |> Enum.reduce(%{}, fn [s, d, w], acc ->
        Map.update(acc, s, %{d => w}, & Map.put(&1, d, w))
        # 逆方向分も追加
        |> Map.update(d, %{s => w}, & Map.put(&1, s, w))
      end)
      |> IO.inspect()

    # 探索済みノード
    # 出発地点は距離0, それ以外は距離INF
    acc = for i <- 2..n, into: %{1 => 0}, do: {i, @inf}

    # 未探索ノード
    unsearched = [{1, 0}]

    solve(unsearched, node_map, acc)
  end

  def solve([], _, acc), do: acc
  def solve(unsearched, node_map, acc) do
    # 未探索ノードの中から最短のものを取得
    [{node, w} | unsearched] = Enum.sort_by(unsearched, &elem(&1, 1))

    # 同じノードで最短以外のものがあれば除去しておく
    unsearched = unsearched |> Enum.reject(& elem(&1, 1) == node)

    # 取得したノードに隣接するノードを検索し、
    new_unsearched =
      Map.get(node_map, node, %{})
      |> Enum.map(fn {nn, ww} -> {nn, ww + w} end)
      # すでに探索済みのものよりコストが低いノードがあれば取得
      |> Enum.filter(fn {nn, ww} -> Map.get(acc, nn) > ww end)

    # 確定ノードを更新
    acc =
        new_unsearched
        |> Enum.reduce(acc, fn {nn, ww}, acc ->
          Map.put(acc, nn, ww)
        end)

    IO.inspect({node, w}, label: "取得したノード")
    IO.inspect(unsearched ++ new_unsearched, label: "未探索ノード")
    IO.inspect(acc, label: "探索済みノード")
    IO.puts("----------------------------------")

    solve(unsearched ++ new_unsearched, node_map, acc)
  end
end
