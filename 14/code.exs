defmodule Solution do
  def part1(input) do
    {polymer, rules} = parse_input(input)

    solution(10, polymer, rules)
  end

  def part2(input) do
    {polymer, rules} = parse_input(input)

    solution(40, polymer, rules)
  end

  def part1_dynamic(input) do
    {polymer, rules} = parse_input(input)

    dynamic(10, polymer, rules, %{})
  end

  def part2_dynamic(input) do
    {polymer, rules} = parse_input(input)

    dynamic(40, polymer, rules, %{})
  end

  def solution(times, polymer, rules) do
    rules = Enum.into(rules, %{})
    pairs = polymer
      |> String.graphemes()
      |> Enum.chunk_every(2, 1, :discard)
      |> Enum.map(&List.to_string/1)
      |> Enum.frequencies()

    {min, max} =
      1..times
      |> Enum.reduce(pairs, fn _, pairs -> round(pairs, rules) end)
      |> Enum.reduce(%{}, fn {pair, value}, freq ->
        [_, last] = String.graphemes(pair)
        Map.update(freq, last, value, & &1 + value)
      end)
      |> then(& Enum.min_max(Map.values(&1)))

    max - min
  end

  def round(pairs, rules) do
    pairs
    |> Enum.reduce(%{}, fn {pair, value}, result ->
      [a, b] = String.graphemes(pair)
      match = Map.get(rules, a <> b)
      if match do
        result
        |> Map.update(a <> match, value, & &1 + value)
        |> Map.update(match <> b, value, & &1 + value)
      else
        Map.put(result, pair, value)
      end
    end)
  end

  def dynamic(times, polymer, rules, cache) do
    pairs = polymer
      |> String.graphemes()
      |> Enum.chunk_every(2, 1, :discard)
      |> Enum.map(&List.to_tuple/1)

    {result, cache} =
      pairs |> Enum.map_reduce(%{}, fn pair, cache ->
        go(times, pair, rules, cache)
      end)

    {min, max} =
      result
      |> Enum.reduce(%{}, fn r, acc -> Map.merge(acc, r, fn _, v1, v2 -> v1 + v2 end) end)
      |> then(& Enum.min_max(Map.values(&1)))

    max - min
  end

  def go(0, {l, r}, rules, cache) do
    {%{r => 1}, cache}
  end

  def go(n, {l, r}, rules, cache) do
    {result, cache} =
      case {Map.get(cache, {n, {l, r}}), Map.get(rules, l <> r)} do
        {nil, nil} -> {%{r => 1}, cache}

        {nil, m} ->
          {resut1, cache} = go(n - 1, {l, m}, rules, cache)
          {resut2, cache} = go(n - 1, {m, r}, rules, cache)
          {Map.merge(resut1, resut2, fn _, v1, v2 -> v1 + v2 end), cache}

        {result, _} -> {result, cache}
      end

    {result, Map.put(cache, {n, {l, r}}, result)}
  end

  def parse_input(input) do
    [polymer, rules] = input |> String.split("\n\n", trim: true)

    rules =
      rules
      |> String.split("\n", trim: true) |> Enum.map(fn line ->
        line
        |> String.split(" -> ", trim: true)
        |> List.to_tuple()
      end)
      |> Enum.into(%{})

    {polymer, rules}
  end
end

defmodule Test do
  @input """
  NNCB

  CH -> B
  HH -> N
  CB -> H
  NH -> C
  HB -> C
  HC -> B
  HN -> C
  NN -> C
  BH -> H
  NC -> B
  NB -> B
  BN -> B
  BB -> N
  BC -> B
  CC -> N
  CN -> C
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
    |> assert(1588)
  end

  def part1_dynamic do
    @input
    |> Solution.part1_dynamic()
    |> assert(1588)
  end

  def part2 do
    @input
    |> Solution.part2()
    |> assert(2188189693529)
  end

  def part2_dynamic do
    @input
    |> Solution.part2_dynamic()
    |> assert(2188189693529)
  end
end

Test.part1()
Test.part1_dynamic()

IO.inspect(Solution.part1(File.read!("input.txt")), label: "Part 1")
#
Test.part2()
Test.part2_dynamic()
IO.inspect(Solution.part2(File.read!("input.txt")), label: "Part 2")
