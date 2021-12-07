defmodule Solution do
  def part1(input) do
    lines = parse_input(input) |> IO.inspect()
    {min, max} = Enum.min_max(lines)
    min..max |> Enum.map(fn position ->
      lines |> Enum.map(fn line -> abs(line - position) end) |> Enum.sum()
    end)
    |> Enum.min()
  end

  def part2(input) do
    lines = parse_input(input)

    {min, max} = Enum.min_max(lines)
    min..max |> Enum.map(fn position ->
      lines |> Enum.map(fn line ->
        steps = abs(line - position)
        (steps + 1) * steps / 2
      end) |> Enum.sum()
    end)
    |> Enum.min()
  end

  def parse_input(input) do
    input
    |> String.split("\n")
    |> Enum.filter(& &1 != "")
    |> Enum.at(0)
    |> String.split(",")
    |> Enum.map(&String.to_integer/1)
  end
end

defmodule Test do
  @input """
  16,1,2,0,4,2,7,1,2,14
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
    |> assert(37)
  end

  def part2 do
    @input
    |> Solution.part2()
    |> assert(168)
  end
end

Test.part1()
IO.inspect(Solution.part1(File.read!("input.txt")), label: "Part 1")
#
Test.part2()
IO.inspect(Solution.part2(File.read!("input.txt")), label: "Part 2")
