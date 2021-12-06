defmodule Solution do
  def part1(input) do
    lines = parse_input(input)

    0..255 |> Enum.reduce(lines, fn day, fish ->
      {zeros, others} = Enum.split_with(fish, & &1 == 0)
      regen = zeros |> Enum.map(fn _ -> 6 end)
      new = zeros |> Enum.map(fn _ -> 8 end)

      others = others |> Enum.map(& &1 - 1)

      regen
      |> Enum.concat(others)
      |> Enum.concat(new)
    end)
    |> Enum.count()
  end

  def part2(input) do
    lines = parse_input(input)

    map = Enum.frequencies(lines)

    0..255 |> Enum.reduce(map, fn _, fish ->
      Enum.reduce(fish, %{}, fn
        {0, number}, fish ->
          fish |>  Map.put(6, number) |> Map.put(8, number)

        {stage, number}, fish ->
          Map.update(fish, stage - 1, number, & &1 + number)
      end)
    end)
    |> Map.values()
    |> Enum.sum()
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
  3,4,3,1,2
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
    |> assert(5934)
  end

  def part2 do
    @input
    |> Solution.part2()
    |> assert(0)
  end
end

Test.part1()
IO.inspect(Solution.part1(File.read!("input.txt")), label: "Part 1")

Test.part2()
IO.inspect(Solution.part2(File.read!("input.txt")), label: "Part 2")
