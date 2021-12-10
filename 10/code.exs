defmodule Solution do

  @points1 %{
    ")" => 3,
    "]" => 57,
    "}" => 1197,
    ">" => 25137
  }

  @points2 %{
    ")" => 1,
    "]" => 2,
    "}" => 3,
    ">" => 4
  }

  @pairs %{
    "(" => ")",
    "[" => "]",
    "{" => "}",
    "<" => ">"
  }

  def part1(input) do
    lines = parse_input(input)

    lines
    |> Enum.map(&find_corrupted/1)
    |> Enum.filter(& length(&1) == 1)
    |> Enum.map(& Map.get(@points1, Enum.at(&1, 0)))
    |> Enum.sum()
  end

  def part2(input) do
    lines = parse_input(input)

    lines
    |> Enum.map(&find_corrupted/1)
    |> Enum.filter(& length(&1) > 1)
    |> Enum.map(fn stack -> Enum.reduce(stack, 0, & &2 * 5 + @points2[@pairs[&1]]) end)
    |> Enum.sort()
    |> then(& Enum.at(&1, div(length(&1), 2)))
  end

  def find_corrupted(line) do
    line |> Enum.reduce_while([], fn char, stack ->
      cond do
         opening?(char) ->
           {:cont, [char | stack]}

         Enum.empty?(stack) ->
           {:halt, char}

        true ->
          [first | rest] = stack
          if @pairs[first] == char, do: {:cont, rest}, else: {:halt, [char]}
      end
    end)
  end

  def opening?(char), do: Enum.member?(Map.keys(@pairs), char)

  def parse_input(input) do
    input |> String.split("\n") |> Enum.filter(& &1 != "") |> Enum.map(&String.graphemes/1)
  end
end

defmodule Test do
  @input """
  [({(<(())[]>[[{[]{<()<>>
  [(()[<>])]({[<{<<[]>>(
  {([(<{}[<>[]}>{[]{[(<()>
  (((({<>}<{<{<>}{[]{[]{}
  [[<[([]))<([[{}[[()]]]
  [{[{({}]{}}([{[{{{}}([]
  {<[[]]>}<{[{[{[]{()[[[]
  [<(<(<(<{}))><([]([]()
  <{([([[(<>()){}]>(<<{{
  <{([{{}}[<[[[<>{}]]]>[]]
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
    |> assert(26397)
  end

  def part2 do
    @input
    |> Solution.part2()
    |> assert(288957)
  end
end

Test.part1()
IO.inspect(Solution.part1(File.read!("input.txt")), label: "Part 1")

Test.part2()
IO.inspect(Solution.part2(File.read!("input.txt")), label: "Part 2")
