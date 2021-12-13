defmodule Solution do
  def part1(input) do
    lines = parse_input(input)

    traverse("start", lines, [], :part1)
  end

  def part2(input) do
    lines = parse_input(input)

    traverse("start", lines, [], :part2)
  end

  def traverse(start, lines, visited, part) do
    lines
    |> Enum.filter(& elem(&1, 0) == start)
    |> Enum.reduce(0, fn {_, cave}, acc ->
      cond do
        cave == "start" -> acc
        cave == "end" -> acc + 1
        big_cave?(cave) -> acc + traverse(cave, lines, visited, part)
        true -> # small cave
          if can_visit?(cave, visited, part) do
            acc + traverse(cave, lines, [cave | visited], part)
          else
            acc
          end
      end
    end)
  end

  def big_cave?(cave), do: Enum.at(String.to_charlist(cave), 0) in ?A..?Z

  def can_visit?(cave, visited, :part1) do
    !Enum.member?(visited, cave)
  end

  def can_visit?(cave, visited, :part2) do
    frequencies = Enum.frequencies(visited)
    Map.get(frequencies, cave) == nil || Enum.count(frequencies, & elem(&1, 1) == 2) == 0
  end

  def parse_input(input) do
    input |> String.split("\n") |> Enum.filter(& &1 != "") |> Enum.flat_map(&parse_line/1)
  end

  def parse_line(line) do
    {a, b} = line |> String.split("-") |> List.to_tuple()
    [{a, b}, {b, a}]
  end
end

defmodule Test do
  @input """
  start-A
  start-b
  A-c
  A-b
  b-d
  A-end
  b-end
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
    |> assert(10)
  end

  def part2 do
    @input
    |> Solution.part2()
    |> assert(36)
  end
end

Test.part1()
IO.inspect(Solution.part1(File.read!("input.txt")), label: "Part 1")

Test.part2()
IO.inspect(Solution.part2(File.read!("input.txt")), label: "Part 2")
