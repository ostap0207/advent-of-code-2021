defmodule Solution do
  def part1(input) do
    map = parse_input(input)
    go(map, map_shape(map), 0)
  end

  def go(map, shape, n) do
    map
    |> go_right(shape)
    |> go_down(shape)
    |> then(fn
      ^map -> n + 1
      updated_map -> go(updated_map, shape, n + 1)
    end)
  end

  def go_right(map, {_, cols}) do
    Enum.reduce(map, map, fn
      {{x, y}, ">"}, new_map ->
        newy = rem(y + 1, cols)

        if Map.get(map, {x, newy}) == "." do
          new_map
          |> Map.put({x, y}, ".")
          |> Map.put({x, newy}, ">")
        else
          new_map
        end

      _, new_map ->
        new_map
    end)
  end

  def go_down(map, {rows, _}) do
    Enum.reduce(map, map, fn
      {{x, y}, "v"}, new_map ->
        newx = rem(x + 1, rows)

        if Map.get(map, {newx, y}) == "." do
          new_map
          |> Map.put({x, y}, ".")
          |> Map.put({newx, y}, "v")
        else
          new_map
        end

      _, new_map ->
        new_map
    end)
  end

  def map_shape(grid) do
    {{rows, cols}, _} = Enum.max_by(grid, & elem(&1, 0))
    {rows + 1, cols + 1}
  end

  def parse_input(input) do
    input
    |> String.split("\n")
    |> Enum.filter(&(&1 != ""))
    |> Enum.with_index()
    |> Enum.reduce(%{}, fn {line, i}, map ->
      line
      |> String.graphemes()
      |> Enum.with_index()
      |> Enum.reduce(map, fn {char, j}, map ->
        Map.put(map, {i, j}, char)
      end)
    end)
  end
end

defmodule Test do
  @input """
  v...>>.vv>
  .vv>>.vv..
  >>.>v>...v
  >>v>>.>.v.
  v>v.vv.v..
  >.>>..v...
  .vv..>.>v.
  v.v..>>v.v
  ....v..v.>
  """

  def assert(actual, expected) do
    if actual == expected do
      IO.puts("Passed!")
    else
      IO.puts("Expected #{inspect(expected)}, actual #{inspect(actual)}")
    end
  end

  def part1 do
    @input
    |> Solution.part1()
    |> assert(58)
  end

  def part2 do
    @input
    |> Solution.part2()
    |> assert(0)
  end
end

Test.part1()
IO.inspect(Solution.part1(File.read!("input.txt")), label: "Part 1")

# Test.part2()
# IO.inspect(Solution.part2(File.read!("input.txt")), label: "Part 2")
