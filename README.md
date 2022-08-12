# ShortestPath

Shortest path problem of an undirected graph from all nodes by Elixir and other languages

## Problem statement

Given is an undirected graph with *N* vertices and *M* edges.
Vertices are in *xy*-plain. 
The *i*-th vertice *Vi* has a position *(Xi, Yi)* for visualization of the graph.
The *j*-th edge is connected between *Vaj* and *Vbj* has a weight of *Wj*.
Find the shortest path between all vertices.

## Constraints

$$ 2 \leq N $$

$$ 1 \leq M \leq \frac{1}{2}N(N-1)$$

$$ 1 \leq i, a, b \leq N$$

$$ 1 \leq j \leq M$$

$$ 1 \leq Wj \leq 1000 $$

## Input

Input is given the file in `test/support/in` in the following format:

```
N M
X1 Y1
...
XN YN
Va1 Vb1 W1
...
VaM VbM WM
```

You can use `ShortestPath.InputReader.read/1` for obtaining *N*, *M*, the list of the lists `[Vaj, Vbj, Wj]` from the file.

## Output

Output the distance *Da,b* of the shortest path between the vertice *Va* and *Vb* for all vertices in the following format, for reducing amount of output:

```
N
D1,2 D1,3 ... D1,N
D2,3 D2,4 ... D2,N
...
DN-1,N
```

You can use `ShortestPath.OutputWriter.puts/1` for outputing in the above format.

## Sample inputs

See the directory `test/support/in`.

## Sample outputs

See the directory `test/support/out`.

## Usage

### Run benchmarks

```
mix run -r bench/shortest_path_bench.exs
```

If `ips` and `average` are `0.50` and `2.00s`, respectively, it means time out of the execution. 

```
##### With input N,M = 1000,499500 #####
Name                     ips        average  deviation         median         99th %
Dijkstra.MainA          0.50         2.00 s     ±0.02%         2.00 s         2.00 s
```

### Generate an input case

```elixir
iex> :rand.seed(:exsss)
iex> ShortestPath.InputCaseGenerator.generate("sample_01.txt", 4, 6) # file_name, n, m
```

You'll get `test/support/in/sample_01.txt`.

## License

Copyright (c) ShortestPathSolvers 2022 

Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at [http://www.apache.org/licenses/LICENSE-2.0](http://www.apache.org/licenses/LICENSE-2.0)

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.

