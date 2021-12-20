defmodule Solution do
  @inf_point {99999999, 99999999}

  def part1(input) do
    {map, image} = parse_input(input)

    enhance_times(2, image, map) |> Map.values() |> Enum.count(&(&1 == "#"))
  end

  def part2(input) do
    {map, image} = parse_input(input)

    enhance_times(50, image, map) |> Map.values() |> Enum.count(&(&1 == "#"))
  end

  def enhance_times(times, image, map) do
    1..times
    |> Enum.reduce({image, 0}, fn _, {image, inf} ->
      enhance({image, inf}, map)
    end)
    |> elem(0)
  end

  def enhance({image, inf}, map) do
    {min_x, min_y} = Enum.min(Map.keys(image))
    {max_x, max_y} = Enum.max(Map.keys(image))

    image =
      for x <- (min_x - 1)..(max_x + 1),
          y <- (min_y - 1)..(max_y + 1),
          into: %{} do
        {{x, y}, calc_pixel({x, y}, image, map, inf)}
      end

    new_inf = if calc_pixel(@inf_point, image, map, inf) == "#", do: 1, else: 0
    {image, new_inf}
  end

  def calc_pixel({x, y}, image, map, inf) do
    binary =
      {x, y}
      |> adjacent()
      |> Enum.map(fn ap ->
        case Map.get(image, ap) do
          nil -> inf
          "." -> 0
          "#" -> 1
        end
      end)
      |> Enum.join()

    {index, _} = Integer.parse(binary, 2)
    Enum.at(map, index)
  end

  def map_shape(grid) do
    {{rows, cols}, _} = Enum.max_by(grid, fn {{row, col}, _} -> row + col end)
    {rows + 1, cols + 1}
  end

  def part2(input) do
    lines = parse_input(input)
  end

  def adjacent({x, y}) do
    [
      {x - 1, y - 1},
      {x - 1, y},
      {x - 1, y + 1},
      {x, y - 1},
      {x, y},
      {x, y + 1},
      {x + 1, y - 1},
      {x + 1, y},
      {x + 1, y + 1}
    ]
  end

  def parse_input(input) do
    [map, image] = input |> String.split("\n\n", trim: true)

    image =
      image
      |> String.split("\n", trim: true)
      |> Enum.with_index()
      |> Enum.reduce(%{}, fn {line, i}, acc ->
        line
        |> String.graphemes()
        |> Enum.with_index()
        |> Enum.reduce(acc, fn {pixel, j}, acc ->
          Map.put(acc, {i, j}, pixel)
        end)
      end)

    {map |> String.graphemes(), image}
  end
end

defmodule Test do
  @input """
  ..#.#..#####.#.#.#.###.##.....###.##.#..###.####..#####..#....#..#..##..###..######.###...####..#..#####..##..#.#####...##.#.#..#.##..#.#......#.###.######.###.####...#.##.##..#..#..#####.....#.#....###..#.##......#.....#..#..#..##..#...##.######.####.####.#.#...#.......#..#.#.#...####.##.#......#..#...##.#.##..#...##.#.##..###.#......#.#.......#.#.#.####.###.##...#.....####.#..#..#.##.#....##..#.####....##...##..#...#......#.#.......#.......##..####..#...#.#.#...##..#.#..###..#####........#..####......#..#

  #..#.
  #....
  ##..#
  ..#..
  ..###
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
    |> assert(35)
  end

  def part2 do
    @input
    |> Solution.part2()
    |> assert(3351)
  end
end

Test.part1()
IO.inspect(Solution.part1(File.read!("input.txt")), label: "Part 1")

Test.part2()
IO.inspect(Solution.part2(File.read!("input.txt")), label: "Part 2")
