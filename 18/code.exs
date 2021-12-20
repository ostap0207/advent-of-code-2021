defmodule Solution do
  def part1(input) do
    lines = parse_input(input)

    lines
    |> Enum.reduce(fn number, acc -> add(acc, number) end)
    |> magnitude()
  end

  def part2(input) do
    lines = parse_input(input)
    length = length(lines)

    Enum.flat_map(0..(length - 1), fn i ->
      Enum.flat_map(0..(length - 1), fn j ->
        if i != j do
          a = Enum.at(lines, i)
          b = Enum.at(lines, j)
          [add(a, b) |> magnitude(), add(b, a) |> magnitude()]
        else
          []
        end
      end)
    end)
    |> Enum.max()
  end

  def add(a, b) do
    "[#{a},#{b}]" |> reduce()
  end

  def reduce(number) do
    result = explode(number)
    result = if result == number, do: split(result), else: result
    result = if result != number, do: reduce(result), else: result
  end

  def split(number) do
    number_for_split = find_number_for_split(number)

    if number_for_split do
      int = String.to_integer(number_for_split)
      a = floor(int / 2)
      b = ceil(int / 2)

      String.replace(number, number_for_split, "[#{a},#{b}]", global: false)
    else
      number
    end
  end

  def explode(number) do
    nested = find_nested(number)

    case nested do
      {from, to, pair} ->
        unwrapped = String.slice(pair, 1..-2)
        [a, b] = String.split(unwrapped, ",") |> Enum.map(&String.to_integer/1)
        {left, rest} = String.split_at(number, from)
        {_, right} = String.split_at(rest, String.length(pair))

        left_number = find_first_number(left, :left)
        left = add_to_number(left, left_number, a, :left)

        right_number = find_first_number(right, :right)
        right = add_to_number(right, right_number, b, :right)

        left <> "0" <> right

      nil ->
        number
    end
  end

  def find_number_for_split(str) do
    str
    |> String.graphemes()
    |> Enum.chunk_every(2, 1, :discard)
    |> Enum.map(&Enum.join/1)
    |> Enum.find(fn possible_number ->
      case Integer.parse(possible_number) do
        {_, ""} -> true
        _ -> false
      end
    end)
  end

  def add_to_number(str, nil, _, _), do: str

  def add_to_number(right, number, to_add, :right) do
    String.replace(right, number, Integer.to_string(String.to_integer(number) + to_add),
      global: false
    )
  end

  def add_to_number(left, number, to_add, :left) do
    left
    |> String.reverse()
    |> String.replace(
      String.reverse(number),
      String.reverse(Integer.to_string(String.to_integer(number) + to_add)),
      global: false
    )
    |> String.reverse()
  end

  def find_first_number(str, :left) do
    find_first_number(String.reverse(str), :right) |> case do
      nil -> nil
      number -> String.reverse(number)
    end
  end

  def find_first_number(str, :right) do
    first_right =
      str
      |> String.graphemes()
      |> Enum.with_index()
      |> Enum.find(fn {char, index} ->
        char not in ["]", "[", ","]
      end)

    if first_right do
      {_, index} = first_right
      find_number(index, str)
    else
      nil
    end
  end


  def find_number(index, str) do
    {_, str} = String.split_at(str, index)

    str
    |> String.graphemes()
    |> Enum.reduce_while("", fn char, acc ->
      case Integer.parse(char) do
        {_, ""} -> {:cont, acc <> char}
        _ -> {:halt, acc}
      end
    end)
  end

  def find_nested(number) do
    index =
      number
      |> String.graphemes()
      |> Enum.with_index()
      |> Enum.reduce_while(0, fn {char, index}, open ->
        cond do
          char == "[" ->
            if open == 4 do
              {:halt, index}
            else
              {:cont, open + 1}
            end

          char == "]" ->
            {:cont, open - 1}

          true ->
            {:cont, open}
        end
      end)

    if index > 0 do
      {_, rest} = String.split_at(number, index)
      [result, rest] = String.split(rest, "]", parts: 2)
      result = result <> "]"
      {index, index + String.length(result), result}
    else
      nil
    end
  end

  def magnitude(number) when is_binary(number),
    do: Code.eval_string(number) |> elem(0) |> magnitude()

  def magnitude([left, right]), do: 3 * magnitude(left) + 2 * magnitude(right)
  def magnitude(number), do: number

  def parse_input(input) do
    input |> String.split("\n") |> Enum.filter(&(&1 != ""))
  end
end

defmodule Test do
  @input """
  [[[0,[5,8]],[[1,7],[9,6]]],[[4,[1,2]],[[1,4],2]]]
  [[[5,[2,8]],4],[5,[[9,9],0]]]
  [6,[[[6,2],[5,6]],[[7,6],[4,7]]]]
  [[[6,[0,7]],[0,9]],[4,[9,[9,0]]]]
  [[[7,[6,4]],[3,[1,3]]],[[[5,5],1],9]]
  [[6,[[7,3],[3,2]]],[[[3,8],[5,7]],4]]
  [[[[5,4],[7,7]],8],[[8,3],8]]
  [[9,3],[[9,9],[6,[4,9]]]]
  [[2,[[7,7],7]],[[5,8],[[9,3],[0,2]]]]
  [[[[5,2],5],[8,[3,7]]],[[5,[7,5]],[4,4]]]
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
    |> assert(4140)
  end

  def part2 do
    @input
    |> Solution.part2()
    |> assert(3993)
  end
end

Test.part1()
IO.inspect(Solution.part1(File.read!("input.txt")), label: "Part 1")

Test.part2()
IO.inspect(Solution.part2(File.read!("input.txt")), label: "Part 2")
