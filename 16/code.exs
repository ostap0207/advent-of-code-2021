defmodule Solution do
  def part1(input) do
    line = parse_input(input) |> Enum.at(0)

    binary = convert(line)

    version(binary, false)
    # lines
    # |> Enum.map(fn line -> convert(line) end)
    # |> Enum.map(fn number -> Integer.to_string(2) end)
    # |> Enum.map(fn binary -> String.graphemes(binary) |> Enum.take(3) |> Enum.join() |> Integer.parse(2) |> elem(0) end)
    # |> Enum.sum()
  end

  def version(line, first) do
    {version, rest} = String.split_at(line, 3)
    {version, _} = Integer.parse(version, 2)
    {type, rest} = String.split_at(rest, 3)
    {type, _} = Integer.parse(type, 2)

    {version, rest} =
      case type do
        4 ->
          {rest, value} = read_literal(rest, "")
          {value, rest}

        type ->
          {lenght_bit, rest} = String.split_at(rest, 1)

          case lenght_bit do
            "0" ->
              {sub_packets, rest} = String.split_at(rest, 15)
              {sub_packets, _} = Integer.parse(sub_packets, 2)
              {sub_packets, rest} = String.split_at(rest, sub_packets)

              {result, _rest} = read_subpackets(sub_packets)
              {calc(type, result), rest}

            "1" ->
              {sub_packets, rest} = String.split_at(rest, 11)
              {sub_packets, _} = Integer.parse(sub_packets, 2)
              {v, rest} =
                1..sub_packets |> Enum.reduce({[], rest}, fn p, {list, rest} ->
                  {v2, rest} = version(rest, true)
                  {[v2 | list], rest}
                end)

              {calc(type, v |> Enum.reverse()), rest}
          end
      end

    {version, rest}
  end

  def read_subpackets(sub_packets) do
    {value, rest} = version(sub_packets, true)
    if ended?(rest) do
      {[value], rest}
    else
      {list, rest} = read_subpackets(rest)
      {[value] ++ list, rest}
    end
  end

  def calc(type, sub_packets) do
    func =
      case type do
        0 -> fn sub_packets -> Enum.sum(sub_packets) end
        1 -> fn sub_packets -> Enum.product(sub_packets) end
        2 -> fn sub_packets -> Enum.min(sub_packets) end
        3 -> fn sub_packets -> Enum.max(sub_packets) end
        5 -> fn sub_packets -> if Enum.at(sub_packets, 0) > Enum.at(sub_packets, 1), do: 1, else: 0 end
        6 -> fn sub_packets -> if Enum.at(sub_packets, 0) < Enum.at(sub_packets, 1), do: 1, else: 0 end
        7 -> fn sub_packets -> if Enum.at(sub_packets, 0) == Enum.at(sub_packets, 1), do: 1, else: 0 end
      end
    func.(sub_packets)
  end

  def read_literal(rest, info_so_far) do
    {info, rest} = String.split_at(rest, 5)
    [a | remb] = String.graphemes(info)

    if a == "1" do
      read_literal(rest, info_so_far <> Enum.join(remb))
    else
      {value, _} = Integer.parse(info_so_far <> Enum.join(remb), 2)
      {rest, value}
    end
  end

  def ended?("") do
    true
  end

  def ended?(rest) do
    rest |> String.graphemes() |> Enum.all?(& &1 == "0")
  end

  def convert(string) do
    string |> String.graphemes()
    |> Enum.map(fn n -> Integer.parse(n, 16) |> elem(0) |> Integer.to_string(2) |> String.pad_leading(4, "0") end)
    |> Enum.join()
  end

  def part2(input) do
    lines = parse_input(input)

  end

  def parse_input(input) do
    input |> String.split("\n") |> Enum.filter(& &1 != "")
  end
end

defmodule Test do
  @input """
  D2FE28
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
    |> assert({2021, "000"})
  end

  def part2 do
    @input
    |> Solution.part2()
    |> assert(0)
  end
end

Test.part1()
IO.inspect(Solution.part1(File.read!("input.txt")), label: "Part 1")
#
# Test.part2()
# IO.inspect(Solution.part2(File.read!("input.txt")), label: "Part 2")
