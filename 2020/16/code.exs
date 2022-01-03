defmodule Solution do
  def part1(input) do
    {rules, your, nearby} = parse_input(input)

    general = rules |> Enum.flat_map(fn {type, r1, r2} -> [r1, r2] end)
    nearby
    |> List.flatten()
    |> Enum.filter(fn number ->
      !Enum.any?(general, fn {from, to} -> number >=from && number <= to end)
    end)
    |> Enum.sum()
  end

  def part2(input) do
    lines = parse_input(input)

  end

  def parse_input(input) do
    [rules, your, nearby] = input |> String.split("\n\n", trim: true)
    rules = rules |> String.split("\n", trim: true) |> Enum.map(fn line ->
      [type, one, two] = String.split(line, [": ", " or "])
      [a1, a2] = String.split(one, "-") |> Enum.map(&String.to_integer/1)
      [b1, b2] = String.split(two, "-") |> Enum.map(&String.to_integer/1)
      {type, {a1, a2}, {b1, b2}}
    end)

    your = your |> String.split("\n", trim: true) |> Enum.at(1) |> String.split(",", trim: true) |> Enum.map(&String.to_integer/1)
    [_ | nearby] = nearby |> String.split("\n", trim: true)

    nearby = nearby |> Enum.map(fn line -> line |> String.split(",", trim: true) |> Enum.map(&String.to_integer/1) end)
    {rules, your, nearby}
  end
end

defmodule Test do
  @input """
  class: 1-3 or 5-7
  row: 6-11 or 33-44
  seat: 13-40 or 45-50

  your ticket:
  7,1,14

  nearby tickets:
  7,3,47
  40,4,50
  55,2,20
  38,6,12
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
    |> assert(71)
  end

  def part2 do
    @input
    |> Solution.part2()
    |> assert(0)
  end
end

Test.part1()
IO.inspect(Solution.part1(File.read!("input.txt")), label: "Part 1")
#
# Test.part2()
# IO.inspect(Solution.part2(File.read!("input.txt")), label: "Part 2")
