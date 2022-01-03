defmodule Solution do
  def part1(input) do
    card_pub_key = 14012298
    door_pub_key = 74241

    card_loop = find_loop(0, 1, 7, card_pub_key)
    loop(card_loop, door_pub_key)
  end

  def find_loop(n, current, subject_number, pub_key) do
    if current == pub_key do
      n
    else
      current = rem(current * subject_number, 20201227)
      find_loop(n + 1, current, subject_number, pub_key)
    end
  end

  def loop(0, _subject_number), do: 1
  def loop(n, subject_number), do: rem(loop(n - 1, subject_number) * subject_number, 20201227)

  def part2(input) do
    lines = parse_input(input)

  end

  def parse_input(input) do
    input |> String.split("\n") |> Enum.filter(& &1 != "")
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
    |> assert(18608573)
  end

  def part2 do
    @input
    |> Solution.part2()
    |> assert(0)
  end
end

Test.part1()
# IO.inspect(Solution.part1(File.read!("input.txt")), label: "Part 1")
#
# Test.part2()
# IO.inspect(Solution.part2(File.read!("input.txt")), label: "Part 2")
