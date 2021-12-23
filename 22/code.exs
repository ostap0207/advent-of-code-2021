defmodule Solution do
  def part1(input) do
    lines = parse_input(input)

    lines
    |> Enum.filter(fn {_, {{x1, x2}, {y1, y2}, {z1, z2}}} ->
      x1 >= -50 && x2 <= 50 && y1 >= -50 && y2 <= 50 && z1 >= -50 && z2 <= 50
    end)
    |> execute_instructions()
  end

  def part2(input) do
    lines = parse_input(input)
    execute_instructions(lines)
  end

  def execute_instructions(cubes) do
    cubes
    |> Enum.reduce([], &turn/2)
    |> Enum.map(&count_cubes/1)
    |> Enum.sum()
  end

  def turn({"on", new_cube}, existing_cubes) do
    existing_cubes
    |> Enum.reduce([new_cube], fn existing_cube, new_cubes ->
      new_cubes |> Enum.flat_map(fn cube -> remove_cube(cube, existing_cube) end)
    end)
    |> Enum.concat(existing_cubes)
  end

  def turn({"off", new_cube}, existing_cubes) do
    Enum.flat_map(existing_cubes, fn existing_cube -> remove_cube(existing_cube, new_cube) end)
  end

  def remove_cube(cube_a, cube_b) do
    intersection = intersection(cube_a, cube_b)

    if intersection do
      split(cube_a, intersection)
    else
      [cube_a]
    end
  end

  def split({{x1, x4}, {y1, y4}, {z1, z4}}, {{x2, x3}, {y2, y3}, {z2, z3}}) do
    xs = [{x1, x2 - 1}, {x2, x3}, {x3 + 1, x4}]
    ys = [{y1, y2 - 1}, {y2, y3}, {y3 + 1, y4}]
    zs = [{z1, z2 - 1}, {z2, z3}, {z3 + 1, z4}]

    for {x1, x2} <- xs,
        {y1, y2} <- ys,
        {z1, z2} <- zs,
        x2 >= x1,
        y2 >= y1,
        z2 >= z1,
        uniq: true do
      {{x1, x2}, {y1, y2}, {z1, z2}}
    end
    |> List.delete({{x2, x3}, {y2, y3}, {z2, z3}})
  end

  def count_cubes({{x1, x2}, {y1, y2}, {z1, z2}}) do
    abs(x2 - x1 + 1) * abs(y2 - y1 + 1) * abs(z2 - z1 + 1)
  end

  def part2(input) do
    lines = parse_input(input)
  end

  def intersection({{x1, x2}, {y1, y2}, {z1, z2}}, {{xx1, xx2}, {yy1, yy2}, {zz1, zz2}}) do
    maxx1 = max(x1, xx1)
    minx2 = min(x2, xx2)
    maxy1 = max(y1, yy1)
    miny2 = min(y2, yy2)
    maxz1 = max(z1, zz1)
    minz2 = min(z2, zz2)

    if minx2 >= maxx1 && miny2 >= maxy1 && minz2 >= maxz1 do
      {{maxx1, minx2}, {maxy1, miny2}, {maxz1, minz2}}
    else
      nil
    end
  end

  def parse_input(input) do
    input |> String.split("\n") |> Enum.filter(&(&1 != "")) |> Enum.map(&parse_line/1)
  end

  def parse_line(line) do
    [command, coords] = String.split(line, " ", trim: true)
    [x, y, z] = String.split(coords, ",")
    [x1, x2] = String.split(x, ["x=", ".."], trim: true) |> Enum.map(&String.to_integer/1)
    [y1, y2] = String.split(y, ["y=", ".."], trim: true) |> Enum.map(&String.to_integer/1)
    [z1, z2] = String.split(z, ["z=", ".."], trim: true) |> Enum.map(&String.to_integer/1)
    {command, {{x1, x2}, {y1, y2}, {z1, z2}}}
  end
end

defmodule Test do
  @input """
  on x=-20..26,y=-36..17,z=-47..7
  on x=-20..33,y=-21..23,z=-26..28
  on x=-22..28,y=-29..23,z=-38..16
  on x=-46..7,y=-6..46,z=-50..-1
  on x=-49..1,y=-3..46,z=-24..28
  on x=2..47,y=-22..22,z=-23..27
  on x=-27..23,y=-28..26,z=-21..29
  on x=-39..5,y=-6..47,z=-3..44
  on x=-30..21,y=-8..43,z=-13..34
  on x=-22..26,y=-27..20,z=-29..19
  off x=-48..-32,y=26..41,z=-47..-37
  on x=-12..35,y=6..50,z=-50..-2
  off x=-48..-32,y=-32..-16,z=-15..-5
  on x=-18..26,y=-33..15,z=-7..46
  off x=-40..-22,y=-38..-28,z=23..41
  on x=-16..35,y=-41..10,z=-47..6
  off x=-32..-23,y=11..30,z=-14..3
  on x=-49..-5,y=-3..45,z=-29..18
  off x=18..30,y=-20..-8,z=-3..13
  on x=-41..9,y=-7..43,z=-33..15
  on x=-54112..-39298,y=-85059..-49293,z=-27449..7877
  on x=967..23432,y=45373..81175,z=27513..53682
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
    |> assert(590_784)
  end

  def part2 do
    @input
    |> Solution.part2()
    |> assert(39_769_202_357_779)
  end
end

Test.part1()
IO.inspect(Solution.part1(File.read!("input.txt")), label: "Part 1")

Test.part2()
IO.inspect(Solution.part2(File.read!("input.txt")), label: "Part 2")
