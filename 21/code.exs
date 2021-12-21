Mix.install([
  {:memoize, "~> 1.4"}
])

defmodule Solution do
  use Memoize

  @rolls [{3, 1}, {4, 3}, {5, 6}, {6, 7}, {7, 6}, {8, 3}, {9, 1}]

  def part1(_) do
    plat_turn1(1, {0, 2}, {0, 8})
  end

  def part2(_) do
    {a, b} = play_turn2({0, 2}, {0, 8})
    max(a, b)
  end

  def plat_turn1(turn, {score1, pos1}, {score2, pos2}) do
    if score2 > 1000 do
      score1 * (turn - 1)
    else
      pos1 = pos1 + rem(turn, 100) + rem(turn + 1, 100) + rem(turn + 2, 100)
      pos1 = if rem(pos1, 10) == 0, do: 10, else: rem(pos1, 10)
      plat_turn1(turn + 3, {score2, pos2}, {score1 + pos1, pos1})
    end
  end

  defmemo play_turn2({score1, pos1}, {score2, pos2}) do
    if score2 >= 21 do
      {0, 1}
    else
      Enum.reduce(@rolls, {0, 0}, fn {roll, universes}, {wins1_acc, wins2_acc} ->
        pos1 = pos1 + roll
        pos1 = if rem(pos1, 10) == 0, do: 10, else: rem(pos1, 10)
        {wins2, wins1} = play_turn2({score2, pos2}, {score1 + pos1, pos1})
        {wins1_acc + wins1 * universes, wins2_acc + wins2 * universes}
      end)
    end
  end
end

defmodule Test do
  @input """

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
    |> assert(1_196_172)
  end

  def part2 do
    @input
    |> Solution.part2()
    |> assert(106_768_284_484_217)
  end
end

Test.part1()
# IO.inspect(Solution.part1(File.read!("input.txt")), label: "Part 1")
#
Test.part2()
# IO.inspect(Solution.part2(File.read!("input.txt")), label: "Part 2")
