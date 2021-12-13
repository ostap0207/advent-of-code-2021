defmodule Solution do
  def part1(input) do
    {coords, [first | _]} = parse_input(input)

    fold(first, coords) |> Enum.count()
  end

  def part2(input) do
    {coords, instructions} = parse_input(input)

    instructions
    |> Enum.reduce(coords, &fold/2)
    |> print()
  end

  def fold(instruction, coords) do
    case instruction do
      {"fold along y", middle} ->
        Enum.map(coords, fn {x, y} -> {x, fold_coord(y, middle)} end)

      {"fold along x", middle} ->
        Enum.map(coords, fn {x, y} -> {fold_coord(x, middle), y} end)
    end
  end

  def fold_coord(coord, middle) do
    if coord > middle, do: coord = middle - (coord - middle), else: coord
  end

  def print(result) do
    {cols, _} = Enum.max_by(result, fn {col, _}  -> col end)
    {_, rows} = Enum.max_by(result, fn {_, row}  -> row end)

    0..rows |> Enum.map(fn row ->
      0..cols |> Enum.map(fn col ->
        if Enum.member?(result, {col, row}) do
          "#"
        else
          " "
        end
      end) |> List.to_string()
    end) |> Enum.join("\n")
    |> IO.puts()
  end

  def parse_input(input) do
    [lines, instructions] = input |> String.split("\n\n", trim: true)
    coords = String.split(lines, "\n", trim: true) |> Enum.map(fn coord ->
      String.split(coord, ",") |> Enum.map(&String.to_integer/1) |> List.to_tuple()
    end)

    instructions = String.split(instructions, "\n", trim: true) |> Enum.map(fn instruction ->
      [fold, line] = String.split(instruction, "=")
      {fold, String.to_integer(line)}
    end)

    {coords, instructions}
  end
end

defmodule Test do
  @input """
  6,10
  0,14
  9,10
  0,3
  10,4
  4,11
  6,0
  6,12
  4,1
  0,13
  10,12
  3,4
  3,0
  8,4
  1,10
  2,14
  8,10
  9,0

  fold along y=7
  fold along x=5
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
    |> assert(17)
  end

  def part2 do
    @input
    |> Solution.part2()
    |> assert(:ok)
  end
end

Test.part1()
IO.inspect(Solution.part1(File.read!("input.txt")), label: "Part 1")

Test.part2()
IO.inspect(Solution.part2(File.read!("input.txt")), label: "Part 2")
