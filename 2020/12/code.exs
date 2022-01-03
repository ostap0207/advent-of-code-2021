defmodule Solution do
  def part1(input) do
    lines = parse_input(input)

    {h, v, _} =
      lines
      |> Enum.reduce({0, 0, 0}, fn {command, value}, {h, v, r} ->
        case command do
          "N" -> {h, v - value, r}
          "S" -> {h, v + value, r}
          "E" -> {h - value, v, r}
          "W" -> {h + value, v, r}
          "R" -> {h, v, r + value}
          "L" -> {h, v, r - value}
          "F" ->
            d = rem(r, 360)
            direction =
              case d do
                0 -> "E"
                90 -> "S"
                180 -> "W"
                270 -> "N"
                -90 -> "N"
                -180 -> "W"
                -270 -> "S"
              end
            case direction do
              "N" -> {h, v - value, r}
              "S" -> {h, v + value, r}
              "E" -> {h - value, v, r}
              "W" -> {h + value, v, r}
            end
        end
      end)
    abs(h) + abs(v)
  end

  def part2(input) do
    lines = parse_input(input)

    {h, v, _} =
      lines
      |> Enum.reduce({0, 0, {-10, -1}}, fn {command, value}, {h, v, {wh, wv}} ->
        IO.inspect({h, v, {wh, wv}})
        case command do
          "N" -> {h, v, {wh, wv - value}}
          "S" -> {h, v, {wh, wv + value}}
          "E" -> {h, v, {wh - value, wv}}
          "W" -> {h, v, {wh + value, wv}}
          "R" ->
            times = div(value, 90)
            r = 1..times |> Enum.reduce({wh, wv}, fn _, p -> rotate(p, "R") end)
            {h, v, r}
          "L" ->
            times = div(value, 90)
            r = 1..times |> Enum.reduce({wh, wv}, fn _, p -> rotate(p, "L") end)
            {h, v, r}
          "F" ->
            {h + wh * value, v + wv * value, {wh, wv}}
        end
      end)
    abs(h) + abs(v)
  end

  def rotate({h, v}, "R") do
    cond do
      h <= 0 && v <= 0 -> {v, h * -1}
      h <= 0 && v >= 0  -> {v, h * -1}
      h >= 0 && v >= 0 -> {v, h * -1}
      h >= 0 && v <= 0  -> {v, h * -1}
    end
  end

  def rotate({h, v}, "L") do
    {h, v} |> rotate("R") |> rotate("R") |> rotate("R")
  end

  def parse_input(input) do
    input |> String.split("\n") |> Enum.filter(& &1 != "")
    |> Enum.map(fn line ->
      [command | rest] = String.graphemes(line)
      {command, String.to_integer(List.to_string(rest))}
    end)
  end
end

defmodule Test do
  @input """
  F10
  N3
  F7
  R90
  F11
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
    |> assert(25)
  end

  def part2 do
    @input
    |> Solution.part2()
    |> assert(286)
  end
end

# Test.part1()
# IO.inspect(Solution.part1(File.read!("input.txt")), label: "Part 1")
#
# Test.part2()
IO.inspect(Solution.part2(File.read!("input.txt")), label: "Part 2")
