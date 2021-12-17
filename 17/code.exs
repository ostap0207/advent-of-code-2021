defmodule Solution do
  def part1(input) do
    {{x1, x2}, {y1, y2}} = parse_input(input)
    velocity = abs(y1) - 1
    floor(velocity * (velocity + 1) / 2)
  end

  def part2(input) do
    {{_, x2} = x_bounds, y_bounds} = parse_input(input)

    0..x2
    |> Enum.reduce([], fn x, list ->
      -500..500
      |> Enum.reduce(list, fn y, list ->
        if go({0, 0}, {x, y}, x_bounds, y_bounds) do
          [{x, y} | list]
        else
          list
        end
      end)
    end)
    |> length()
  end

  def go({px, py}, {x, y}, {x1, x2} = x_bounds, {y1, y2} = y_bounds) do
    cond do
      px > x2 || py < y1 ->
        false

      px < x1 && x == 0 ->
        false

      px <= x2 && px >= x1 && py >= y1 && py <= y2 ->
        true

      true ->
        speed = {max(0, x - 1), y - 1}
        go({px + x, py + y}, speed, x_bounds, y_bounds)
    end
  end

  def parse_input(input) do
    [_, x, y] =
      input
      |> String.split("\n")
      |> Enum.filter(&(&1 != ""))
      |> Enum.at(0)
      |> String.split([": x=", ", y="])

    [x1, x2] = String.split(x, "..") |> Enum.map(&String.to_integer/1)
    [y1, y2] = String.split(y, "..") |> Enum.map(&String.to_integer/1)
    {{x1, x2}, {y1, y2}}
  end
end

defmodule Test do
  @input """
  target area: x=20..30, y=-10..-5
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
    |> assert(45)
  end

  def part2 do
    @input
    |> Solution.part2()
    |> assert(112)
  end
end

Test.part1()
IO.inspect(Solution.part1(File.read!("input.txt")), label: "Part 1")

Test.part2()
IO.inspect(Solution.part2(File.read!("input.txt")), label: "Part 2")
