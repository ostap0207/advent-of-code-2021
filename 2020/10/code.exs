defmodule Solution do
  def part1(input) do
    lines = parse_input(input)

    %{1 => ones, 3 => threes} =
      [Enum.max(lines) + 3 | [0 | lines]]
      |> Enum.sort()
      |> Enum.chunk_every(2, 1, :discard)
      |> Enum.map(fn [a, b] -> b - a end)
      |> Enum.frequencies()

    ones * threes
  end

  def part2(input) do
    lines = parse_input(input)
    outlets = lines ++ [0, Enum.max(lines) + 3] |> Enum.sort()

    outlets |> Enum.reduce({-1, [], []}, fn outlet, {last, temp, result} ->
      if outlet - last <=2 do
        {outlet, [outlet | temp], result}
      else
        if length(temp) > 2 do
          {outlet, [outlet], [Enum.reverse(temp) | result]}
        else
          {outlet, [outlet], result}
        end
      end
    end)
    |> elem(2)
    |> Enum.map(&solve/1)
    |> Enum.reduce(&*/2)
  end


  def solve([]), do: 0
  def solve([_]), do: 1
  def solve([_, _]), do: 1

  def solve([head | rest]) do
    rest
    |> Enum.with_index()
    |> Enum.filter(fn {a, _} -> a - head <=3 end)
    |> Enum.map(fn {_, index} -> solve(Enum.slice(rest, index..(length(rest) - 1))) end)
    |> Enum.sum()
  end

  def parse_input(input) do
    input |> String.split("\n") |> Enum.filter(& &1 != "") |> Enum.map(&String.to_integer/1)
  end
end

defmodule Test do
  @input """
  28
  33
  18
  42
  31
  14
  46
  20
  48
  47
  24
  23
  49
  45
  19
  38
  39
  11
  1
  32
  25
  35
  8
  17
  7
  9
  4
  2
  34
  10
  3
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
    |> assert(220)
  end

  def part2 do
    @input
    |> Solution.part2()
    |> assert(19208)
  end
end

Test.part1()
IO.inspect(Solution.part1(File.read!("input.txt")), label: "Part 1")

Test.part2()
IO.inspect(Solution.part2(File.read!("input.txt")), label: "Part 2")
