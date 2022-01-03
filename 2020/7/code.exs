defmodule Solution do
  def part1(input) do
    lines = parse_input(input)
    result = find_bags(["shiny gold"], [], lines) |> Enum.count()
    result - 1
  end

  def find_bags([], result, lines) do
    result
  end

  def find_bags(to_find, result, lines) do
    new_result = Enum.concat(result, to_find) |> Enum.uniq()
    to_find =
      to_find |> Enum.reduce([], fn color, acc ->
        case Map.get(lines, color) do
          nil -> acc
          bags -> Enum.concat(acc, Enum.map(bags, & elem(&1, 0)))
        end
      end)
      |> Enum.uniq()

    find_bags(to_find, new_result, lines)
  end

  def part2(input) do
    lines = parse_input(input)

    find_contains("shiny gold", lines)
  end

  def find_contains(bag, lines) do
    bags = Map.get(lines, bag)
    case bags do
      [nil] -> 0
      bags ->
        bags
        |> Enum.map(fn {color, number} -> number * (1 + find_contains(color, lines)) end)
        |> Enum.sum()
    end
  end

  def parse_input(input) do
    input
    |> String.split("\n")
    |> Enum.filter(& &1 != "")
    |> Enum.map(&parse_line/1)
    |> Enum.into(%{})
  end

  def parse_line(line) do
    {bag, contains} = String.split(line, " bags contain ") |> List.to_tuple()

    contains =
      contains
      |> String.split(",", trim: true)
      |> Enum.map(fn
        "no other bags." -> nil

        bag ->
          [number, type, color | _] = String.split(bag)
          {"#{type} #{color}", String.to_integer(number)}
      end)

    {bag, contains}
  end
end

defmodule Test do
  @input """
  light red bags contain 1 bright white bag, 2 muted yellow bags.
  dark orange bags contain 3 bright white bags, 4 muted yellow bags.
  bright white bags contain 1 shiny gold bag.
  muted yellow bags contain 2 shiny gold bags, 9 faded blue bags.
  shiny gold bags contain 1 dark olive bag, 2 vibrant plum bags.
  dark olive bags contain 3 faded blue bags, 4 dotted black bags.
  vibrant plum bags contain 5 faded blue bags, 6 dotted black bags.
  faded blue bags contain no other bags.
  dotted black bags contain no other bags.
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
    |> assert(4)
  end

  def part2 do
    @input
    |> Solution.part2()
    |> assert(32)
  end
end

# Test.part1()
# IO.inspect(Solution.part1(File.read!("input.txt")), label: "Part 1")

Test.part2()
IO.inspect(Solution.part2(File.read!("input.txt")), label: "Part 2")
