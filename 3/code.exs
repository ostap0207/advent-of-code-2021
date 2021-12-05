defmodule Solution do
  def part1(input) do
    lines = parse_input(input)
    chars = Enum.map(lines, &String.to_charlist/1)
    sample = Enum.at(chars, 0)

    gamma =
      sample
      |> Enum.with_index()
      |> Enum.map(fn {_, index} -> select_bit(chars, index, &Kernel.>/2) end)
      |> parse_chars()

    epsilon =
      sample
      |> Enum.with_index()
      |> Enum.map(fn {_, index} -> select_bit(chars, index, &Kernel.<=/2) end)
      |> parse_chars()

    gamma * epsilon
  end

  def part2(input) do
    lines = parse_input(input)
    chars = Enum.map(lines, &String.to_charlist/1)

    ox = chars |> filter_bits(0, &Kernel.>/2) |> parse_chars()
    co2 = chars |> filter_bits(0, &Kernel.<=/2) |> parse_chars()

    ox * co2
  end

  defp select_bit(chars, index, condition) do
    zeros = Enum.filter(chars, fn c -> Enum.at(c, index) == ?0 end) |> length()
    ones = Enum.filter(chars, fn c -> Enum.at(c, index) == ?1 end) |> length()
    if condition.(zeros, ones), do: ?0, else: ?1
  end

  defp filter_bits([result], _index, _condition), do: result
  defp filter_bits(chars, index, condition) do
    zeros = Enum.filter(chars, fn c -> Enum.at(c, index) == ?0 end) |> length()
    ones = Enum.filter(chars, fn c -> Enum.at(c, index) == ?1 end) |> length()

    required_bit = if condition.(zeros, ones), do: ?0, else: ?1
    remaining = Enum.filter(chars, fn c -> Enum.at(c, index) == required_bit end)
    filter_bits(remaining, index + 1, condition)
  end

  defp parse_chars(chars) do
    {integer, _} =
      chars
      |> List.to_string()
      |> Integer.parse(2)

    integer
  end

  def parse_input(input) do
    input |> String.split("\n") |> Enum.filter(& &1 != "")
  end
end

defmodule Test do
  def assert(actual, expected) do
    if actual == expected do
      IO.puts("Passed!")
    else
      IO.puts("Expected #{expected}, actual #{actual}")
    end
  end

  def part1 do
    """
    00100
    11110
    10110
    10111
    10101
    01111
    00111
    11100
    10000
    11001
    00010
    01010
    """
    |> Solution.part1()
    |> assert(198)
  end

  def part2 do
    """
    00100
    11110
    10110
    10111
    10101
    01111
    00111
    11100
    10000
    11001
    00010
    01010
    """
    |> Solution.part2()
    |> assert(230)
  end
end
#
Test.part1()
IO.inspect(Solution.part1(File.read!("input.txt")), label: "Part 1")

Test.part2()
IO.inspect(Solution.part2(File.read!("input.txt")), label: "Part 2")
