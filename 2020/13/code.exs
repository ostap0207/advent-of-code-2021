defmodule Solution do
  def part1(input) do
    {time, buses} = parse_input1(input)

    {bus, next_time} = buses |> Enum.map(fn bus -> {bus, bus - rem(time, bus)} end) |> Enum.min_by(& elem(&1, 1))
    bus * next_time
  end

  def part2(input) do
    buses = parse_input2(input)

    buses = buses |> Enum.with_index() |> Enum.filter(& elem(&1, 0) > 0)

    buses
    |> Enum.reduce(fn {bus1, offset1}, {bus2, offset2} ->
      offset2 = if offset2 == 0, do: bus2, else: offset2
      bus3 =
        Stream.iterate(bus2, & &1 + offset2)
        |> Enum.find(fn time -> rem(time + offset1, bus1) == 0 end)
      {bus3, bus1 * offset2}
    end)
    |> then(&elem(&1, 0))
  end

  def parse_input1(input) do
    [time, buses] = input |> String.split("\n") |> Enum.filter(& &1 != "")

    {
      String.to_integer(time),
      buses |> String.split(",") |> Enum.filter(& &1 != "x") |> Enum.map(&String.to_integer/1)
    }
  end
  def parse_input2(input) do
    [_, buses] = input |> String.split("\n") |> Enum.filter(& &1 != "")

    buses |> String.replace("x", "0") |> String.split(",") |> Enum.map(&String.to_integer/1)
  end
end

defmodule Test do
  @input """
  939
  7,13,x,x,59,x,31,19
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
    |> assert(295)
  end

  def part2 do
    @input
    |> Solution.part2()
    |> assert(1068781)
  end
end

Test.part1()
IO.inspect(Solution.part1(File.read!("input.txt")), label: "Part 1")

Test.part2()
IO.inspect(Solution.part2(File.read!("input.txt")), label: "Part 2")
