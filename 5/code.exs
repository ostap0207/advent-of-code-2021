defmodule Solution do
  def part1(input) do
    lines = parse_input(input)

    lines
    |> Enum.filter(&direct?/1)
    |> count_overlaps()
  end

  def part2(input) do
    lines = parse_input(input)
    count_overlaps(lines)
  end

  def count_overlaps(lines) do
    lines
    |> Enum.flat_map(&points/1)
    |> Enum.frequencies()
    |> Map.values()
    |> Enum.count(& &1 > 1)
  end

  def points({x1, y1, x2, y2}) do
    count = max(abs(x2 - x1), abs(y2 - y1))
    xstep = floor((x2 - x1) / count)
    ystep = floor((y2 - y1) / count)

    xpoints = 0..count |> Enum.map(& &1 * xstep + x1)
    ypoints = 0..count |> Enum.map(& &1 * ystep + y1)

    Enum.zip(xpoints, ypoints)
  end

  defp direct?({x1, y1, x2, y2}), do: x1 == x2 || y1 == y2

  def parse_input(input) do
    input
    |> String.split("\n")
    |> Enum.filter(& &1 != "")
    |> Enum.map(&parse_line/1)
  end

  def parse_line(line) do
    [_ | coords] = Regex.run(~r/([0-9]+),([0-9]+) -> ([0-9]+),([0-9]+)/, line)

    coords
    |> Enum.map(&String.to_integer/1)
    |> List.to_tuple()
  end
end

defmodule Test do
  @input """
  0,9 -> 5,9
  8,0 -> 0,8
  9,4 -> 3,4
  2,2 -> 2,1
  7,0 -> 7,4
  6,4 -> 2,0
  0,9 -> 2,9
  3,4 -> 1,4
  0,0 -> 8,8
  5,5 -> 8,2
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
    |> assert(5)
  end

  def part2 do
    @input
    |> Solution.part2()
    |> assert(12)
  end
end

Test.part1()
IO.inspect(Solution.part1(File.read!("input.txt")), label: "Part 1")
#
Test.part2()
IO.inspect(Solution.part2(File.read!("input.txt")), label: "Part 2")
