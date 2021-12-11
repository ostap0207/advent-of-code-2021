defmodule Solution do
  def part1(input) do
    grid = parse_input(input) |> map_grid()

    1..100 |> Enum.reduce({grid, 0}, fn _, {grid, acc} ->
      {grid, flashes} = grid |> increase() |> iluminate()
      {grid, acc + flashes}
    end)
    |> elem(1)
  end

  def part2(input) do
    grid = parse_input(input) |> map_grid()

    1..10000 |> Enum.reduce_while(grid, fn step, grid ->
      {grid, flashes} = grid |> increase() |> iluminate()

      if flashes == 100, do: {:halt, step}, else: {:cont, grid}
    end)
  end

  def map_grid(lines) do
    for {line, i} <- Enum.with_index(lines),
        {value, j} <- Enum.with_index(line), into: %{} do
      {{i, j}, value}
    end
  end

  def increase(grid) do
    Enum.map(grid, fn {point, value} -> {point, value + 1} end) |> Enum.into(%{})
  end

  def iluminate({grid, acc}) do
    if has_bright?(grid) do
      grid
      |> Enum.filter(&bright?/1)
      |> Enum.reduce({grid, acc}, fn {point, _}, {grid, acc} ->
        point
        |> adjacent()
        |> Enum.reduce(grid, fn point, grid ->
          case Map.get(grid, point) do
            value when value in [0, nil] -> grid
            value -> Map.put(grid, point, value + 1)
          end
        end)
        |> then(& {Map.put(&1, point, 0), acc + 1})
      end)
      |> iluminate()
    else
      {grid, acc}
    end
  end

  def iluminate(grid), do: iluminate({grid, 0})

  def bright?({_, value}), do: value >= 10
  def has_bright?(grid), do: Enum.count(grid, &bright?/1) > 0

  def adjacent({x, y}) do
    [
      {x - 1, y - 1},
      {x + 1, y + 1},
      {x + 1, y - 1},
      {x - 1, y + 1},
      {x - 1, y},
      {x + 1, y},
      {x, y - 1},
      {x, y + 1}
    ]
  end

  def parse_input(input) do
    input |> String.split("\n") |> Enum.filter(& &1 != "") |> Enum.map(fn line ->
      line |> String.graphemes() |> Enum.map(&String.to_integer/1)
    end)
  end
end

defmodule Test do
  @input """
  5483143223
  2745854711
  5264556173
  6141336146
  6357385478
  4167524645
  2176841721
  6882881134
  4846848554
  5283751526
  """

  def assert(actual, expected) do
    if actual == expected do
      IO.puts("Passed!")
    else
      IO.puts("Expected #{expected}, actual #{actual}")
    end
  end

  def part1 do
    @input
    |> Solution.part1()
    |> assert(1656)
  end

  def part2 do
    @input
    |> Solution.part2()
    |> assert(195)
  end
end

Test.part1()
IO.inspect(Solution.part1(File.read!("input.txt")), label: "Part 1")
#
Test.part2()
IO.inspect(Solution.part2(File.read!("input.txt")), label: "Part 2")
