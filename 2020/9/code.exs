defmodule Solution do
  def part1(input) do
    numbers = parse_input(input)

    to = length(numbers)
    size = 25

    prev = Enum.take(numbers, size)
    size..to |> Enum.reduce_while(prev, fn pos, prev ->
      number = Enum.at(numbers, pos)
      if find_summers(number, Enum.take(prev, -size)) do
        {:cont, prev ++ [number]}
      else
        {:halt, number}
      end
    end)
  end

  def find_summers(number, numbers) do
    Enum.reduce_while(numbers, 0, fn n1, _  ->
      Enum.reduce_while(numbers, 0, fn n2, _  ->
        if n1 + n2 == number, do: {:halt, {:halt, true}}, else: {:cont, {:cont, :false}}
      end)
    end)
  end

  def part2(input) do
    number = part1(input)
    numbers = parse_input(input)

    2..number |> Enum.reduce_while(0, fn window, _ ->
      result =
        numbers
        |> Stream.chunk_every(window, 1)
        |> Enum.find(& Enum.sum(&1) == number)
      if result do
        {:halt, Enum.min(result) + Enum.max(result)}
      else
        {:cont, 0}
      end
    end)

  end

  def parse_input(input) do
    input |> String.split("\n") |> Enum.filter(& &1 != "") |> Enum.map(&String.to_integer/1)
  end
end

defmodule Test do
  @input """
  35
  20
  15
  25
  47
  40
  62
  55
  65
  95
  102
  117
  150
  182
  127
  219
  299
  277
  309
  576
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
    |> assert(127)
  end

  def part2 do
    @input
    |> Solution.part2()
    |> assert(62)
  end
end

# Test.part1()
IO.inspect(Solution.part1(File.read!("input.txt")), label: "Part 1")

# Test.part2()
IO.inspect(Solution.part2(File.read!("input.txt")), label: "Part 2")
