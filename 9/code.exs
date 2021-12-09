defmodule Solution do
  def part1(input) do
    map = parse_input(input)

    map
    |> low_points()
    |> Enum.map(&(get(map, &1) + 1))
    |> Enum.sum()
  end

  def part2(input) do
    map = parse_input(input)

    map
    |> low_points()
    |> Enum.map(&find_basin(map, &1))
    |> Enum.map(&Enum.count/1)
    |> Enum.sort()
    |> Enum.take(-3)
    |> Enum.reduce(&*/2)
  end

  def low_points(map) do
    rows = length(map)
    cols = map |> Enum.at(0) |> length()

    for row <- 0..rows-1,
        col <- 0..cols-1,
        point = {row, col},
        low?(map, point) do
      point
    end
  end

  def find_basin(map, start) do
    adjacent(start)
    |> Enum.filter(&higher?(map, start, &1))
    |> Enum.flat_map(&find_basin(map, &1))
    |> Enum.uniq()
    |> Enum.concat([start])
  end

  def higher?(map, p1, p2) do
    get(map, p1) < get(map, p2) && get(map, p2) < 9
  end

  def low?(map, point) do
    value = get(map, point)

    point
    |> adjacent()
    |> Enum.map(&get(map, &1))
    |> Enum.all?(&(&1 > value))
  end

  def adjacent({x, y}) do
    [
      {x - 1, y},
      {x + 1, y},
      {x, y - 1},
      {x, y + 1}
    ]
  end

  def get(map, {x, y}) do
    rows = length(map)
    cols = Enum.at(map, 0) |> length()

    cond do
      x <= -1 || x >= rows -> 10
      y <= -1 || x >= cols -> 10
      true -> Enum.at(map, x) |> Enum.at(y)
    end
  end

  def parse_input(input) do
    input |> String.split("\n") |> Enum.filter(& &1 != "") |> Enum.map(fn line ->
      line |> String.graphemes() |> Enum.map(&String.to_integer/1)
    end)
  end
end

defmodule Test do
  @input """
  2199943210
  3987894921
  9856789892
  8767896789
  9899965678
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
    |> assert(15)
  end

  def part2 do
    @input
    |> Solution.part2()
    |> assert(1134)
  end
end

Test.part1()
577 = IO.inspect(Solution.part1(File.read!("input.txt")), label: "Part 1")

Test.part2()
1069200 = IO.inspect(Solution.part2(File.read!("input.txt")), label: "Part 2")
