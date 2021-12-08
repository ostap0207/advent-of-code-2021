defmodule Solution do
  def part1(input) do
    lines = parse_input(input)
    lengths = Enum.frequencies([8, 2, 5, 5, 4, 5, 6, 3, 7, 6])

    lines
    |> Enum.map(fn {_, digits} ->
      digits |> Enum.filter(& check_uniq(lengths, &1)) |> Enum.count()
    end)
    |> Enum.sum()
  end

  def part2(input) do
    lines = parse_input(input)

    lines
    |> Enum.map(&solve/1)
    |> Enum.sum()
  end

  def solve({examples, digits}) do
    initial =
      Enum.reduce(examples, %{}, fn example, initial ->
        case String.length(example) do
          2 -> Map.put(initial, 1, example)
          3 -> Map.put(initial, 7, example)
          4 -> Map.put(initial, 4, example)
          7 -> Map.put(initial, 8, example)
          _ -> initial
        end
      end)

    one = Map.get(initial, 1)
    four = Map.get(initial, 4)
    seven = Map.get(initial, 7)
    eight = Map.get(initial, 8)

    lenght_5 = Enum.filter(examples, fn s -> String.length(s) == 5 end)
    {[two], three_or_five} = Enum.split_with(lenght_5, fn s -> minus(s, four) |> Enum.count() == 3 end)
    {[three], [five]} =  Enum.split_with(three_or_five, fn s -> minus(s, two) |> Enum.count() == 1 end)

    lenght_6 = Enum.filter(examples, fn s -> String.length(s) == 6 end)
    {[zero], six_or_nine} = Enum.split_with(lenght_6, fn s -> minus(s, five) |> Enum.count() == 2 end)
    {[nine], [six]} =  Enum.split_with(six_or_nine, fn s -> minus(s, seven) |> Enum.count() == 3 end)

    solution = Enum.with_index([zero, one, two, three, four, five, six, seven, eight, nine])

    digits
    |> Enum.map(fn d -> Enum.find(solution, & equal(elem(&1, 0), d)) |> elem(1) |> Integer.to_string() end)
    |> Enum.join()
    |> String.to_integer()
  end

  def equal(a, b) do
    minus(a, b) |> Enum.count() == 0 && minus(b, a) |> Enum.count() == 0
  end

  def minus(a, b) do
    amapset = String.graphemes(a) |> MapSet.new()
    bmapset = String.graphemes(b) |> MapSet.new()
    MapSet.difference(amapset, bmapset)|> Enum.to_list()
  end

  def parse_input(input) do
    input
    |> String.split("\n")
    |> Enum.filter(& &1 != "")
    |> Enum.map(&parse_line/1)
  end

  def parse_line(line) do
    {a, b} =
      line
      |> String.split("|", trim: true)
      |> List.to_tuple()
    {String.split(a), String.split(b)}
  end

  def check_uniq(lengths, digit) do
    lengths[String.length(digit)] == 1
  end
end

defmodule Test do
  @input """
  be cfbegad cbdgef fgaecd cgeb fdcge agebfd fecdb fabcd edb | fdgacbe cefdb cefbgd gcbe
  edbfga begcd cbg gc gcadebf fbgde acbgfd abcde gfcbed gfec | fcgedb cgb dgebacf gc
  fgaebd cg bdaec gdafb agbcfd gdcbef bgcad gfac gcb cdgabef | cg cg fdcagb cbg
  fbegcd cbd adcefb dageb afcb bc aefdc ecdab fgdeca fcdbega | efabcd cedba gadfec cb
  aecbfdg fbg gf bafeg dbefa fcge gcbea fcaegb dgceab fcbdga | gecf egdcabf bgf bfgea
  fgeab ca afcebg bdacfeg cfaedg gcfdb baec bfadeg bafgc acf | gebdcfa ecba ca fadegcb
  dbcfg fgd bdegcaf fgec aegbdf ecdfab fbedc dacgb gdcebf gf | cefg dcbef fcge gbcadfe
  bdfegc cbegaf gecbf dfcage bdacg ed bedf ced adcbefg gebcd | ed bcgafe cdgba cbgef
  egadfb cdbfeg cegd fecab cgb gbdefca cg fgcdab egfdb bfceg | gbdfcae bgc cg cgb
  gcafb gcf dcaebfg ecagb gf abcdeg gaef cafbge fdbac fegbdc | fgae cfgab fg bagce
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
    |> assert(26)
  end

  def part2 do
    @input
    |> Solution.part2()
    |> assert(61229)
  end
end

Test.part1()
IO.inspect(Solution.part1(File.read!("input.txt")), label: "Part 1")

Test.part2()
IO.inspect(Solution.part2(File.read!("input.txt")), label: "Part 2")
