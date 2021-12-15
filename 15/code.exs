Mix.install([
  {:priority_queue, "1.0.0"}
])

defmodule Solution do
  def part1(input) do
    grid = parse_input(input)
    {r, c} = shape(grid)

    risk = Enum.map(grid, fn {k, _} -> {k, 99_999_999_999} end) |> Enum.into(%{})
    risk = Map.put(risk, {0, 0}, 0)
    open = PriorityQueue.new() |> PriorityQueue.put({0, {0, 0}})

    {risk, _} = go(open, risk, grid)
    Map.get(risk, {r - 1, c - 1})
  end

  def part2(input) do
    grid = parse_input(input) |> extend()
    {r, c} = shape(grid)

    risk = Enum.map(grid, fn {k, _} -> {k, 99_999_999_999} end) |> Enum.into(%{})
    risk = Map.put(risk, {0, 0}, 0)
    open = PriorityQueue.new() |> PriorityQueue.put({0, {0, 0}})

    {risk, _} = go(open, risk, grid)
    Map.get(risk, {r - 1, c - 1})
  end

  def go(open, risk, grid) do
    if PriorityQueue.empty?(open) do
      {risk, open}
    else
      {{current_risk, current}, open} = PriorityQueue.pop(open)

      {risk, open} =
        current
        |> adjacent()
        |> Enum.reduce({risk, open}, fn neighbour, {risk, open} ->
          if neighbour_risk = Map.get(grid, neighbour) do
            tentative_risk = current_risk + neighbour_risk

            if tentative_risk < Map.get(risk, neighbour) do
              {Map.put(risk, neighbour, tentative_risk),
               PriorityQueue.put(open, tentative_risk, neighbour)}
            else
              {risk, open}
            end
          else
            {risk, open}
          end
        end)

      go(open, risk, grid)
    end
  end

  def extend(grid) do
    {r, c} = shape(grid)

    grid
    |> Enum.flat_map(fn {{x, y}, value} ->
      for i <- 0..4, j <- 0..4 do
        value = value + i + j
        value = if rem(value, 9) == 0, do: 9, else: rem(value, 9)
        {{x + i * r, y + j * c}, value}
      end
    end)
    |> Enum.into(%{})
  end

  def adjacent({x, y}) do
    [
      {x + 1, y},
      {x, y + 1},
      {x, y - 1},
      {x - 1, y}
    ]
  end

  def to_map(grid) do
    for {line, i} <- Enum.with_index(grid), {value, j} <- Enum.with_index(line), into: %{} do
      {{i, j}, value}
    end
  end

  def shape(grid) do
    {{rows, cols}, _} = Enum.max_by(grid, fn {{row, col}, _} -> row + col end)
    {rows + 1, cols + 1}
  end

  def parse_input(input) do
    input
    |> String.split("\n")
    |> Enum.filter(&(&1 != ""))
    |> Enum.map(fn line ->
      line |> String.graphemes() |> Enum.map(&String.to_integer/1)
    end)
    |> to_map()
  end
end

defmodule Test do
  @input """
  1163751742
  1381373672
  2136511328
  3694931569
  7463417111
  1319128137
  1359912421
  3125421639
  1293138521
  2311944581
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
    |> assert(40)
  end

  def part2 do
    @input
    |> Solution.part2()
    |> assert(315)
  end
end

Test.part1()
IO.inspect(Solution.part1(File.read!("input.txt")), label: "Part 1")

Test.part2()
IO.inspect(Solution.part2(File.read!("input.txt")), label: "Part 2")
