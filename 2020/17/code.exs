defmodule Solution do
  @operators ["+", "*"]

  def part1(input) do
    lines = parse_input(input)
    lines |> Enum.map(&evaluate1/1) |> Enum.sum()
  end

  def part2(input) do
    lines = parse_input(input)
    lines |> Enum.map(&evaluate2/1) |> Enum.sum()
  end

  def evaluate1(expression) do
    operator_index = find(expression, &(&1 in @operators))

    cond do
      operator_index > 0 ->
        {operator, a, b} = split(expression, operator_index)
        operation(operator, evaluate1(a), evaluate1(b))

      wrapped?(expression) ->
        String.slice(expression, 1..-2) |> evaluate1()

      true ->
        String.to_integer(expression)
    end
  end

  def evaluate2(expression) do
    add_index = find(expression, &(&1 == "+"))
    multiply_index = find(expression, &(&1 == "*"))

    cond do
      multiply_index > 0 ->
        {operator, a, b} = split(expression, multiply_index)
        operation(operator, evaluate2(a), evaluate2(b))

      add_index > 0 ->
        {operator, a, b} = split(expression, add_index)
        operation(operator, evaluate2(a), evaluate2(b))

      wrapped?(expression) ->
        String.slice(expression, 1..-2) |> evaluate2()

      true ->
        String.to_integer(expression)
    end
  end

  def find(expression, check) do
    expression
    |> String.graphemes()
    |> Enum.with_index()
    |> Enum.reverse()
    |> Enum.reduce_while(0, fn {char, index}, open ->
      cond do
        check.(char) and open == 0 ->
          {:halt, index}

        char == ")" ->
          {:cont, open + 1}

        char == "(" ->
          {:cont, open - 1}

        true ->
          {:cont, open}
      end
    end)
  end

  def wrapped?(expression) do
    String.at(expression, 0) == "(" && String.at(expression, String.length(expression) - 1) == ")"
  end

  def split(expression, index) do
    {a, rest} = String.split_at(expression, index)
    {operator, b} = String.split_at(rest, 1)
    {operator, a, b}
  end

  def operation("+", a, b), do: a + b
  def operation("*", a, b), do: a * b

  def parse_input(input) do
    input
    |> String.split("\n")
    |> Enum.filter(&(&1 != ""))
    |> Enum.map(&String.replace(&1, " ", ""))
  end
end

defmodule Test do
  @input """
  5 * 9 * (7 * 3 * 3 + 9 * 3 + (8 + 6 * 4))
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
    |> assert(12240)
  end

  def part2 do
    @input
    |> Solution.part2()
    |> assert(669_060)
  end
end

Test.part1()
IO.inspect(Solution.part1(File.read!("input.txt")), label: "Part 1")

Test.part2()
IO.inspect(Solution.part2(File.read!("input.txt")), label: "Part 2")
