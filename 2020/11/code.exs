defmodule Solution do
  def part1(input) do
    grid = parse_input(input) |> Grid.to_map()

    grid
    |> run_round()
    |> Enum.count(& elem(&1, 1) == "#")
  end

  def run_round(grid) do
    result =
      grid
      |> Grid.map_points()
      |> Enum.reduce(grid, fn point, new_grid ->
        case Map.get(grid, point) do
          "L" ->
            occupied =
              point
              |> adjacent()
              |> Enum.map(& Map.get(grid, &1))
              |> Enum.count(& &1 == "#")
            if occupied == 0 do
              Map.put(new_grid, point, "#")
            else
              new_grid
            end
          "." ->
            new_grid

          "#" ->
            occupied =
              point
              |> adjacent()
              |> Enum.map(& Map.get(grid, &1))
              |> Enum.count(& &1 == "#")

            if occupied >=4 do
              Map.put(new_grid, point, "L")
            else
              new_grid
            end
        end
      end)

    if result == grid do
      result
    else
      run_round(result)
    end
  end

  def part2(input) do
    grid = parse_input(input) |> Grid.to_map() |> IO.inspect()

    grid
    |> run_round2()
    # |> run_round2() |> Grid.to_grid() |> IO.inspect() |> Grid.to_map()
    |> Enum.count(& elem(&1, 1) == "#")
  end

  def run_round2(grid) do
    IO.inspect("STEP")
    {{rows, cols}, _} = Enum.max_by(grid, fn {{row, col}, _} -> row + col end)
    result =
      grid
      |> Grid.map_points()
      |> Enum.reduce(grid, fn point, new_grid ->
        case Map.get(grid, point) do
          "L" ->
            occupied =
              0..7
              |> Enum.reduce_while(false, fn way, occupied ->
                direction = visible(point, {rows, cols}, way)
                visible_seat = Enum.find(direction, & Map.get(grid, &1) != ".")
                if Map.get(grid, visible_seat) == "#" do
                  {:halt, true}
                else
                  {:cont, false}
                end
              end)

            if !occupied do
              Map.put(new_grid, point, "#")
            else
              new_grid
            end
          "." ->
            new_grid

          "#" ->
            occupied =
              0..7
              |> Enum.reduce_while(0, fn way, occupied ->
                direction = visible(point, {rows, cols}, way)
                visible_seat = Enum.find(direction, & Map.get(grid, &1) != ".")
                if Map.get(grid, visible_seat) == "#" do
                  if occupied + 1 >= 5 do
                    {:halt, occupied + 1}
                  else
                    {:cont, occupied + 1}
                  end
                else
                  {:cont, occupied}
                end
              end)

            if occupied >= 5 do
              Map.put(new_grid, point, "L")
            else
              new_grid
            end
        end
      end)

    if result == grid do
      result
    else
      run_round2(result)
    end
  end

  def adjacent({x, y}) do
    [
      {x - 1, y - 1},
      {x + 1, y + 1},
      {x + 1, y - 1},
      {x - 1, y + 1},
      {x - 1, y},
      {x + 1, y},
      {x, y - 1},
      {x, y + 1}
    ]
  end

  def visible({x, y}, {rows, cols}) do
    [
      Enum.zip(Stream.cycle([x]), y..0) -- [{x, y}],
      Enum.zip(Stream.cycle([x]), y..cols)  -- [{x, y}],
      Enum.zip(x..0, Stream.cycle([y]))  -- [{x, y}],
      Enum.zip(x..rows, Stream.cycle([y]))  -- [{x, y}],
      Enum.zip(x..0, y..0)  -- [{x, y}],
      Enum.zip(x..0, y..cols)  -- [{x, y}],
      Enum.zip(x..rows, y..cols)  -- [{x, y}],
      Enum.zip(x..rows, y..0) -- [{x, y}]
    ]
  end

  def visible({x, y}, {rows, cols}, 0), do: Enum.zip(Stream.cycle([x]), y..0) -- [{x, y}]
  def visible({x, y}, {rows, cols}, 1), do: Enum.zip(Stream.cycle([x]), y..cols)  -- [{x, y}]
  def visible({x, y}, {rows, cols}, 2), do: Enum.zip(x..0, Stream.cycle([y]))  -- [{x, y}]
  def visible({x, y}, {rows, cols}, 3), do: Enum.zip(x..rows, Stream.cycle([y]))  -- [{x, y}]
  def visible({x, y}, {rows, cols}, 4), do: Enum.zip(x..0, y..0)  -- [{x, y}]
  def visible({x, y}, {rows, cols}, 5), do: Enum.zip(x..0, y..cols)  -- [{x, y}]
  def visible({x, y}, {rows, cols}, 6), do: Enum.zip(x..rows, y..cols)  -- [{x, y}]
  def visible({x, y}, {rows, cols}, 7), do: Enum.zip(x..rows, y..0) -- [{x, y}]

  def parse_input(input) do
    input |> String.split("\n") |> Enum.filter(& &1 != "") |> Enum.map(fn line ->
      line |> String.graphemes()
    end)
  end
end

defmodule Test do
  @input """
  L.LL.LL.LL
  LLLLLLL.LL
  L.L.L..L..
  LLLL.LL.LL
  L.LL.LL.LL
  L.LLLLL.LL
  ..L.L.....
  LLLLLLLLLL
  L.LLLLLL.L
  L.LLLLL.LL
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
    |> assert(37)
  end

  def part2 do
    @input
    |> Solution.part2()
    |> assert(26)
  end
end

defmodule Grid do
  def load(lines, :integer) do
    lines
    |> load_str()
    |> Enum.map(& Enum.map(&1, fn s -> String.to_integer(s) end))
  end

  def load(lines, :string) do
    load_str(lines)
  end

  defp load_str(lines) do
    Enum.map(lines, & String.split(&1, " ", trim: true))
  end

  def set(matrix, new_value, ri, ci) do
    set_when(matrix, new_value, fn _, eri, eci -> eri == ri && eci == ci end)
  end

  def set_when(matrix, new_value, fun) do
    matrix
    |> Enum.with_index()
    |> Enum.map(fn {row, eri} ->
      row |> Enum.with_index() |> Enum.map(fn {value, eci} ->
        if fun.(value, eri, eci) do
          new_value
        else
          value
        end
      end)
    end)
  end

  def row(matrix, row) do
    Enum.at(matrix, row)
  end

  def column(matrix, column) do
    Enum.map(matrix, & Enum.at(&1, column))
  end

  def diagonal(matrix) do
    length = length(matrix)
    for i <- 0..length - 1 do
      get(matrix, i, i)
    end
  end

  def get(matrix, row, column) do
    matrix |> Enum.at(row) |> Enum.at(column)
  end

  def to_map(grid) do
    for {line, i} <- Enum.with_index(grid),
        {value, j} <- Enum.with_index(line), into: %{} do
      {{i, j}, value}
    end
  end

  def to_grid(map) do
    {{rows, cols}, _} = Enum.max_by(map, fn {{row, col}, _} -> row + col end)
    0..rows |> Enum.map(fn r ->
      0..cols |> Enum.map(fn c ->
        Map.get(map, {r, c})
      end)
    end)
  end

  def points(grid) do
    rows = length(grid)
    cols = length(Enum.at(grid, 0))
    for r <- 0..rows - 1, c <- 0..cols - 1, do: {r, c}
  end

  def map_points(grid) do
    {{rows, cols}, _} = Enum.max_by(grid, fn {{row, col}, _} -> row + col end)
    for r <- 0..rows, c <- 0..cols, do: {r, c}
  end
end

# Test.part1()
# IO.inspect(Solution.part1(File.read!("input.txt")), label: "Part 1")
# #
# Test.part2()
IO.inspect(Solution.part2(File.read!("input.txt")), label: "Part 2")
