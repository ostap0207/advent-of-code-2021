defmodule Solution do
  def part1(input) do
    lines = parse_input(input)

    with_early_return(fn return ->
      # These were detected by inspecting results on smaller examples and ensuring that z value does not grow
      # 1----------------------------------------------------------------------------------------------------14 (minus 3)
      #   2---------------------------------------------------------------------------------------13 (minus 7)
      #     3-4 (must be the same) 5-6 (plus 4) 7-8 (plus 3) 9-------------------------12 (minus 6)
      #                                                         10-11 (always 1 9)
      for i1 <- 9..4, i2 <- 9..8, i3 <- 9..1, i5 <- 5..1, i7 <- 6..1, i9 <- 9..7, i13 <- 1..2, i14 <- 1..6 do
        number = [i1, i2, i3, i3, i5, i5 + 4, i7, i7 + 3, i9, 1, 9, i9 - 6, i13, i14]
        result = execute(lines, number)
        if Map.get(result, "z") == 0 do
          return.(Enum.map(number, &Integer.to_string/1) |> Enum.join())
        end
      end
    end)
  end

  def part2(input) do
    lines = parse_input(input)

    with_early_return(fn return ->
      # These are just reversed to find the min value
      for i1 <- 4..9, i2 <- 8..9, i3 <- 1..9, i5 <- 1..5, i7 <- 1..6, i9 <- 7..9, i13 <- 2..1, i14 <- 6..1 do
        number = [i1, i2, i3, i3, i5, i5 + 4, i7, i7 + 3, i9, 1, 9, i9 - 6, i13, i14]
        result = execute(lines, number)
        if Map.get(result, "z") == 0 do
          return.(Enum.map(number, &Integer.to_string/1) |> Enum.join())
        end
      end
    end)
  end

  def with_early_return(loop) do
    try do
      loop.(fn result ->
        raise result
      end)
    rescue
      e in RuntimeError -> e.message
    end
  end

  def execute(lines, input) do
    lines |> Enum.reduce_while(%{"x" => 0, "y" => 0, "z" => 0, "w" => 0, "i" => 0}, fn line, register ->
      case line do
        {"inp", variable} ->
          input = Enum.at(input, Map.get(register, "i"))
          if input do
            {:cont, register |> Map.put(variable, input) |> Map.put("i", Map.get(register, "i") + 1)}
          else
            {:halt, register}
          end

        {"add", v1, v2} -> {:cont, Map.put(register, v1, resolve(register, v1) + resolve(register, v2))}
        {"mul", v1, v2} -> {:cont, Map.put(register, v1, resolve(register, v1) * resolve(register, v2))}
        {"mod", v1, v2} -> {:cont, Map.put(register, v1, rem(resolve(register, v1), resolve(register, v2)))}
        {"div", v1, v2} -> {:cont, Map.put(register, v1, floor(resolve(register, v1)/resolve(register, v2)))}
        {"eql", v1, v2} ->
          result = if resolve(register, v1) == resolve(register, v2), do: 1, else: 0
          {:cont, Map.put(register, v1, result)}
      end
    end)
  end

  def resolve(register, variable) do
    case Integer.parse(variable) do
      {result, ""} -> result
      :error -> Map.get(register, variable)
    end
  end

  def parse_input(input) do
    input |> String.split("\n") |> Enum.filter(& &1 != "") |> Enum.map(&parse_line/1)
  end

  def parse_line(line) do
    String.split(line, " ") |> List.to_tuple()
  end
end

defmodule Test do
  @input """
  inp w
  mul x 0
  add x z
  mod x 26
  div z 1
  add x 10
  eql x w
  eql x 0
  mul y 0
  add y 25
  mul y x
  add y 1
  mul z y
  mul y 0
  add y w
  add y 10
  mul y x
  add z y
  inp w
  mul x 0
  add x z
  mod x 26
  div z 1
  add x 13
  eql x w
  eql x 0
  mul y 0
  add y 25
  mul y x
  add y 1
  mul z y
  mul y 0
  add y w
  add y 5
  mul y x
  add z y
  inp w
  mul x 0
  add x z
  mod x 26
  div z 1
  add x 15
  eql x w
  eql x 0
  mul y 0
  add y 25
  mul y x
  add y 1
  mul z y
  mul y 0
  add y w
  add y 12
  mul y x
  add z y
  inp w
  mul x 0
  add x z
  mod x 26
  div z 26
  add x -12
  eql x w
  eql x 0
  mul y 0
  add y 25
  mul y x
  add y 1
  mul z y
  mul y 0
  add y w
  add y 12
  mul y x
  add z y
  inp w
  mul x 0
  add x z
  mod x 26
  div z 1
  add x 14
  eql x w
  eql x 0
  mul y 0
  add y 25
  mul y x
  add y 1
  mul z y
  mul y 0
  add y w
  add y 6
  mul y x
  add z y
  inp w
  mul x 0
  add x z
  mod x 26
  div z 26
  add x -2
  eql x w
  eql x 0
  mul y 0
  add y 25
  mul y x
  add y 1
  mul z y
  mul y 0
  add y w
  add y 4
  mul y x
  add z y
  inp w
  mul x 0
  add x z
  mod x 26
  div z 1
  add x 13
  eql x w
  eql x 0
  mul y 0
  add y 25
  mul y x
  add y 1
  mul z y
  mul y 0
  add y w
  add y 15
  mul y x
  add z y
  inp w
  mul x 0
  add x z
  mod x 26
  div z 26
  add x -12
  eql x w
  eql x 0
  mul y 0
  add y 25
  mul y x
  add y 1
  mul z y
  mul y 0
  add y w
  add y 3
  mul y x
  add z y
  inp w
  mul x 0
  add x z
  mod x 26
  div z 1
  add x 15
  eql x w
  eql x 0
  mul y 0
  add y 25
  mul y x
  add y 1
  mul z y
  mul y 0
  add y w
  add y 7
  mul y x
  add z y
  inp w
  mul x 0
  add x z
  mod x 26
  div z 1
  add x 11
  eql x w
  eql x 0
  mul y 0
  add y 25
  mul y x
  add y 1
  mul z y
  mul y 0
  add y w
  add y 11
  mul y x
  add z y
  inp w
  mul x 0
  add x z
  mod x 26
  div z 26
  add x -3
  eql x w
  eql x 0
  mul y 0
  add y 25
  mul y x
  add y 1
  mul z y
  mul y 0
  add y w
  add y 2
  mul y x
  add z y
  inp w
  mul x 0
  add x z
  mod x 26
  div z 26
  add x -13
  eql x w
  eql x 0
  mul y 0
  add y 25
  mul y x
  add y 1
  mul z y
  mul y 0
  add y w
  add y 12
  mul y x
  add z y
  inp w
  mul x 0
  add x z
  mod x 26
  div z 26
  add x -12
  eql x w
  eql x 0
  mul y 0
  add y 25
  mul y x
  add y 1
  mul z y
  mul y 0
  add y w
  add y 4
  mul y x
  add z y
  inp w
  mul x 0
  add x z
  mod x 26
  div z 26
  add x -13
  eql x w
  eql x 0
  mul y 0
  add y 25
  mul y x
  add y 1
  mul z y
  mul y 0
  add y w
  add y 11
  mul y x
  add z y
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
    |> assert("99995969919326")
  end

  def part2 do
    @input
    |> Solution.part2()
    |> assert("48111514719111")
  end
end

Test.part1()
IO.inspect(Solution.part1(File.read!("input.txt")), label: "Part 1")

Test.part2()
IO.inspect(Solution.part2(File.read!("input.txt")), label: "Part 2")
