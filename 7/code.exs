defmodule Solution do
  def part1(input) do
    crabs = parse_input(input)
    count_fuel(crabs, fn crab, pos -> abs(crab - pos) end)
  end

  def part2(input) do
    crabs = parse_input(input)

    count_fuel(crabs, fn crab, pos ->
      steps = abs(crab - pos)
      (steps + 1) * steps / 2
    end)
  end

  defp count_fuel(crabs, fuel_func) do
    {min, max} = Enum.min_max(crabs)
    min..max
    |> Enum.map(fn pos ->
      Enum.map(crabs, fn crab -> fuel_func.(crab, pos) end) |> Enum.sum()
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
