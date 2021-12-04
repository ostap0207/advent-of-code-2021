defmodule Solution do
  def part1(input) do
    lines = parse_input(input)
    {goes, boards} = parse_boards(lines)

    {winner_board, go} = find_first_winner(boards, goes)
    sum = sum_board(winner_board)
    sum * go
  end

  def part2(input) do
    lines = parse_input(input)
    {goes, boards} = parse_boards(lines)

    {winner_board, go} = find_last_winner(boards, goes)
    sum = sum_board(winner_board)
    sum * go
  end

  def parse_boards(lines) do
    [goes_str | board_lines] = lines
    goes = goes_str
      |> String.split(",")
      |> Enum.map(&String.to_integer/1)

    boards = board_lines
      |> Enum.map(& String.replace(&1, "  ", " "))
      |> Enum.map(& String.split(&1, " "))
      |> Enum.map(& Enum.filter(&1, fn s -> s != "" end))
      |> Enum.map(& Enum.map(&1, fn s -> String.to_integer(s) end))
      |> Enum.chunk_every(5)

    {goes, boards}
  end

  def sum_board(board) do
    board
    |> List.flatten()
    |> Enum.filter(fn n -> n > 0 end)
    |> Enum.sum()
  end

  def find_first_winner(boards, goes) do
    Enum.reduce_while(goes, boards, fn go, boards ->
      boards = Enum.map(boards, & replace(&1, go))
      winner_board = Enum.find(boards, &board_wins?/1)

      if winner_board do
        {:halt, {winner_board, go}}
      else
        {:cont, boards}
      end
    end)
  end

  def find_last_winner(boards, goes) do
    Enum.reduce_while(goes, {boards, nil, nil}, fn go, {boards, last_winner, last_go} ->
      boards = Enum.map(boards, & replace(&1, go))
      {winners, remaining_boards} = Enum.split_with(boards, &board_wins?/1)

      {boards, winner_board, go} = if !Enum.empty?(winners) do
        winner_board = Enum.at(winners, 0)
        {remaining_boards, winner_board, go}
      else
        {boards, last_winner, last_go}
      end

      if Enum.empty?(boards) do
        {:halt, {winner_board, go}}
      else
        {:cont, {boards, winner_board, go}}
      end
    end)
  end

  def board_wins?(board) do
    row_wins =
      Enum.any?(board, fn row ->
        Enum.all?(row, fn value -> value == -1 end)
      end)
    column_wins =
      Enum.reduce_while(0..4, false, fn index, _ ->
        if Enum.all?(board, fn row -> Enum.at(row, index) == -1 end) do
          {:halt, true}
        else
          {:cont, false}
        end
      end)

    row_wins || column_wins
  end

  def replace(board, go) do
    board
    |> Enum.map(fn row ->
      row |> Enum.map(fn value ->
        if value == go do
          -1
        else
          value
        end
      end)
    end)
  end

  def parse_input(input) do
    input |> String.split("\n") |> Enum.filter(& &1 != "")
  end
end

defmodule Test do
  @input """
  7,4,9,5,11,17,23,2,0,14,21,24,10,16,13,6,15,25,12,22,18,20,8,19,3,26,1

  22 13 17 11  0
   8  2 23  4 24
  21  9 14 16  7
   6 10  3 18  5
   1 12 20 15 19

   3 15  0  2 22
   9 18 13 17  5
  19  8  7 25 23
  20 11 10 24  4
  14 21 16 12  6

  14 21 17 24  4
  10 16 15  9 19
  18  8 23 26 20
  22 11 13  6  5
   2  0 12  3  7
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
    |> assert(4512)
  end

  def part2 do
    @input
    |> Solution.part2()
    |> assert(1924)
  end
end

Test.part1()
Test.part2()
IO.inspect(Solution.part1(File.read!("input.txt")), label: "Part 1")
IO.inspect(Solution.part2(File.read!("input.txt")), label: "Part 2")
