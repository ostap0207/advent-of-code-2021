defmodule Solution do
  def part1(input) do
    commands = parse_input(input)
    {:cont, acc} = execute(0, 0, commands, [])
    acc
  end

  def part2(input) do
    commands = parse_input(input)
    commands
    |> Enum.with_index()
    |> Enum.filter(fn {{cmd, _}, _} -> cmd == "jmp" || cmd == "nop" end)
    |> Enum.map(fn {_, index} -> index end)
    |> Enum.reduce_while(0, fn index_to_change, _ ->
      commands = List.update_at(commands, index_to_change, &invert/1)
      execute(0, 0, commands, [])
    end)
  end

  def invert({"jmp", value}), do: {"nop", value}
  def invert({"nop", value}), do: {"jmp", value}

  def execute(acc, current, commands, executed) do
    cond do
      current == length(commands) ->
        {:halt, acc}

      Enum.member?(executed, current) ->
        {:cont, 0}

      true ->
        case Enum.at(commands, current) do
          {"nop", _} -> execute(acc, current + 1, commands, [current | executed])
          {"acc", value} -> execute(acc + value, current + 1, commands, [current | executed])
          {"jmp", value} -> execute(acc, current + value, commands, [current | executed])
        end
    end
  end

  def parse_input(input) do
    input |> String.split("\n") |> Enum.filter(& &1 != "") |> Enum.map(&parse_line/1)
  end

  def parse_line(line) do
    [command, value] = String.split(line)
    {command, String.to_integer(value)}
  end
end

defmodule Test do
  @input """
  nop +0
  acc +1
  jmp +4
  acc +3
  jmp -3
  acc -99
  acc +1
  jmp -4
  acc +6
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
    |> assert(5)
  end

  def part2 do
    @input
    |> Solution.part2()
    |> assert(8)
  end
end

# Test.part1()
# IO.inspect(Solution.part1(File.read!("input.txt")), label: "Part 1")
#
# Test.part2()
IO.inspect(Solution.part2(File.read!("input.txt")), label: "Part 2")
