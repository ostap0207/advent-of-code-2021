defmodule Solution do
  def part1(input) do
    lines = parse_input(input)

    lines |> Enum.reduce(%{}, fn {mask, numbers}, acc ->
      numbers |> Enum.reduce(acc, fn {cell, number}, acc ->
        binary = Integer.to_string(number, 2) |> pad() |> String.graphemes() |> Enum.reverse()
        pairs = Enum.zip(binary, mask)
        {result, _} =
          Enum.map(pairs, fn
            {b, "X"} -> b
            {_, c} -> c
          end)
          |> Enum.join()
          |> String.reverse()
          |> Integer.parse(2)
        Map.put(acc, cell, result)
      end)
    end)
    |> Map.values()
    |> Enum.sum()
  end

  def part2(input) do
    lines = parse_input(input)

    lines |> Enum.reduce(%{}, fn {mask, numbers}, acc ->
      numbers |> Enum.reduce(acc, fn {cell, number}, acc ->
        binary = Integer.to_string(cell, 2) |> pad() |> String.graphemes() |> Enum.reverse()
        pairs = Enum.zip(binary, mask)
        new = Enum.map(pairs, fn
          {_, "X"} -> "X"
          {_, "1"} -> "1"
          {b, "0"} -> b
        end)
        floating = Enum.count(new, & &1 == "X")
        addresses =
          0..floor(:math.pow(2,floating)) - 1 |> Enum.map(fn f ->
            fb = ("0000000000000000000000000000000000000" <> Integer.to_string(f, 2)) |> String.reverse()
            {result, _} =
              fb |> String.graphemes() |> Enum.reduce(Enum.join(new), fn digit, acc ->
                String.replace(acc, "X", digit, global: false)
              end)
              |> String.reverse()
              |> Integer.parse(2)
            result
          end)
        addresses |> Enum.reduce(acc, fn address, acc ->
          Map.put(acc, address, number)
        end)
      end)
    end)
    |> Map.values()
    |> Enum.sum()
  end

  def pad(string) do
    "000000000000000000000000000000000000000" <> string
  end

  def parse_input(input) do
    input |> String.split("\n") |> Enum.filter(& &1 != "") |> Enum.reduce([], fn line, acc ->
      case line do
        "mask = " <> mask -> [{Enum.reverse(String.graphemes(mask)), []}] ++ acc

        line ->
          [{mask, mem} | rest] = acc
          [n, c] = line |> String.replace("mem[", "") |> String.split("] = ", trim: true) |> Enum.map(&String.to_integer/1)
          mem = mem ++ [{n, c}]
          [{mask, mem} | rest]
      end
    end)
    |> Enum.reverse()
  end
end

defmodule Test do
  @input """
  mask = 000000000000000000000000000000X1001X
  mem[42] = 100
  mask = 00000000000000000000000000000000X0XX
  mem[26] = 1
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
    |> assert(165)
  end

  def part2 do
    @input
    |> Solution.part2()
    |> assert(208)
  end
end

Test.part1()
IO.inspect(Solution.part1(File.read!("input.txt")), label: "Part 1")

Test.part2()
IO.inspect(Solution.part2(File.read!("input.txt")), label: "Part 2")
