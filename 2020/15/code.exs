defmodule Solution do
  def part1(input) do
    turns(input, 2020)
  end

  def part2(input) do
    turns(input, 30000000)
  end

  def turns(input, number) do
    lines = parse_input(input)
    spoken = lines |> Enum.with_index() |> Enum.reduce(%{}, fn {number, index}, acc ->
      Map.put(acc, number, [index + 1])
    end)
    last = lines |> Enum.reverse() |> Enum.at(0)

    (length(lines) + 1)..number |> Enum.reduce({spoken, last}, fn turn, {spoken, last} ->
      last_spoken = Map.get(spoken, last)
      new =
        case last_spoken do
          [one] -> 0
          [one, two | rest] -> one - two
        end
      spoken = Map.update(spoken, new, [turn], fn existing -> [turn | existing] end)

      {spoken, new}
    end)
    |> elem(1)
  end

  def parse_input(input) do
    input |> String.split("\n") |> Enum.filter(& &1 != "") |> Enum.at(0) |> String.split(",") |> Enum.map(&String.to_integer/1)
  end
end

defmodule Test do
  @input """
  0,3,6
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
    |> assert(436)
  end

  def part2 do
    @input
    |> Solution.part2()
    |> assert(175594)
  end
end

Test.part1()
IO.inspect(Solution.part1(File.read!("input.txt")), label: "Part 1")
#
Test.part2()
IO.inspect(Solution.part2(File.read!("input.txt")), label: "Part 2")
