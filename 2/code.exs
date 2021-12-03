defmodule Solution do
  def part1(input) do
    lines = parse_input(input)

    {h, v} =
      lines
      |> Enum.reduce({0, 0}, fn
        "forward " <> steps, {h, v} ->
          {h + String.to_integer(steps), v}
        "down " <> steps, {h, v} ->
          {h, v + String.to_integer(steps)}
        "up " <> steps, {h, v} ->
          {h, v - String.to_integer(steps)}
      end)

    h * v
  end

  def part2(input) do
    lines = parse_input(input)

    {h, v, _} =
      lines
      |> Enum.reduce({0, 0, 0}, fn
        "forward " <> steps, {h, v, a} ->
          {h + String.to_integer(steps), v + a * String.to_integer(steps), a}
        "down " <> steps, {h, v, a} ->
          {h, v, a + String.to_integer(steps)}
        "up " <> steps, {h, v, a} ->
          {h, v, a - String.to_integer(steps)}
      end)

    h * v
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
    forward 5
    down 5
    forward 8
    up 3
    down 8
    forward 2
    """
    |> Solution.part1()
    |> assert(150)
  end

  def part2 do
    """
    forward 5
    down 5
    forward 8
    up 3
    down 8
    forward 2
    """
    |> Solution.part2()
    |> assert(900)
  end
end

Test.part1()
Test.part2()
IO.inspect(Solution.part1(File.read!("input.txt")), label: "Part 1")
IO.inspect(Solution.part2(File.read!("input.txt")), label: "Part 2")
