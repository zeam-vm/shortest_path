# ShortestPath

Shortest path problem of an undirected graph from all nodes by Elixir and other languages

## Usage

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

