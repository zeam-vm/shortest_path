defmodule ShortestPath.Dijkstra.MainA do
  @behaviour ShortestPath.SolverFromWeightedEdgeList
  @moduledoc """
  Simple Dijkstra's algorithm based on https://products.sint.co.jp/topsic/blog/dijkstras-algorithm.
  """
  @inf 1_000_000_000_000

  @doc """
  Returns a list of lists weights between nodes from a list of lists of weighted edges.
  """
  @spec main(
          pos_integer(),
          pos_integer(),
          ShortestPath.SolverFromWeightedEdgeList.weighted_edge_list()
        ) ::
          ShortestPath.SolverFromWeightedEdgeList.weight_between_nodes_list()
  @impl true
  def main(n, _, vicinities) do
    # 各頂点
    node_map =
      vicinities
      |> Enum.reduce(%{}, fn [s, d, w], acc ->
        Map.update(acc, s, %{d => w}, &Map.put(&1, d, w))
        # 逆方向分も追加
        |> Map.update(d, %{s => w}, &Map.put(&1, s, w))
      end)

    # 各ノードにダイクストラ法を実行
    for start_node <- 1..n do
      # 探索済みノード
      # 出発地点は距離0, それ以外は距離INF
      acc =
        for(i <- 1..n, into: %{}, do: {i, @inf})
        |> Map.put(start_node, 0)

      # 未探索ノード
      unsearched = [{start_node, 0}]

      dijkstra(unsearched, node_map, acc)
    end
  end

  @doc false
  @spec dijkstra(list(), map(), map()) ::
          ShortestPath.SolverFromWeightedEdgeList.weight_between_nodes_list()
  def dijkstra([], _, acc), do: acc |> Map.values()

  def dijkstra(unsearched, node_map, acc) do
    # 未探索ノードの中から最短のものを取得
    [{node, w} | unsearched] = Enum.sort_by(unsearched, &elem(&1, 1))

    # 同じノードで最短以外のものがあれば除去しておく
    unsearched = unsearched |> Enum.reject(&(elem(&1, 0) == node))

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

    # IO.inspect({node, w}, label: "取得したノード")
    # IO.inspect(unsearched ++ new_unsearched, label: "未探索ノード")
    # IO.inspect(acc, label: "探索済みノード")
    # IO.puts("----------------------------------")

    dijkstra(unsearched ++ new_unsearched, node_map, acc)
  end
end
