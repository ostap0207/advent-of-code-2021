Mix.install([
  {:memoize, "~> 1.4"}
])

defmodule Solution do
  use Memoize

  @scores %{
    "A" => 1,
    "B" => 10,
    "C" => 100,
    "D" => 1000,
  }
  @rooms %{
    "A" => 2,
    "B" => 4,
    "C" => 6,
    "D" => 8,
  }

  @desired [
    [],
    [],
    ["A", "A", "A", "A"],
    [],
    ["B", "B", "B", "B"],
    [],
    ["C", "C", "C", "C"],
    [],
    ["D", "D", "D", "D"]
  ]

  def part1(input) do
    hallway = [".", ".", "#", ".", "#", ".", "#",  ".", "#",  ".", "."]
    # levels = [
    #   [],
    #   [],
    #   ["B", "D", "D", "A"],
    #   [],
    #   ["C", "C", "B", "D"],
    #   [],
    #   ["B", "B", "A", "C"],
    #   [],
    #   ["D", "A", "C", "A"]
    # ]
    levels = [
      [],
      [],
      ["D", "D", "D", "C"],
      [],
      ["D", "C", "B", "A"],
      [],
      ["B", "B", "A", "B"],
      [],
      ["A", "A", "C", "C"]
    ]
    # {hallway, levels, score} = move_from_level("B", 6, 0, 3, hallway, levels, 0) |> IO.inspect()
    # {hallway, levels, score} = move_rooms("C", {4, 0}, {6, 0}, {hallway, levels, score}) |> IO.inspect()
    # {hallway, levels, score} = move_from_level("D", 4, 1, 5, hallway, levels, score) |> IO.inspect()
    # {hallway, levels, score} = move_from_hallway("B", 3, 4, {hallway, levels, score}) |> IO.inspect()
    # {hallway, levels, score} = move_rooms("B", {2, 0}, {4, 0}, {hallway, levels, score}) |> IO.inspect()
    # {hallway, levels, score} = move_from_level("D", 8, 0, 7, hallway, levels, score) |> IO.inspect()
    # {hallway, levels, score} = move_from_level("A", 8, 1, 9, hallway, levels, score) |> IO.inspect()
    # {hallway, levels, score} = move_from_hallway("D", 7, 8, {hallway, levels, score}) |> IO.inspect()
    # {hallway, levels, score} = move_from_hallway("D", 5, 8, {hallway, levels, score}) |> IO.inspect()
    # {hallway, levels, score} = move_from_hallway("A", 9, 2, {hallway, levels, score}) |> IO.inspect()
    # find_available_rooms(["B", "C", "#", "D", "#", "D", "#", ".", "#", ".", "A"], 5) |> IO.inspect()
    go(hallway, levels, 0, 9999999999)
    # |> IO.inspect()
  end

  def go(hallway, levels, score, min_score) do
    Memoize.Cache.get_or_run({__MODULE__, :resolve, [{hallway, levels, score}]}, fn ->
      if score > min_score do
        {:not_found}
      else
      # print({hallway, levels, score}, label: "start")
      {hallway, levels, score} =
        0..8 |> Enum.reduce_while({hallway, levels, score}, fn _, {hallway, levels, score} ->
          result =
            hallway |> Enum.with_index() |> Enum.reduce({hallway, levels, score}, fn {pod, index}, {hallway, levels, score} ->
              if pod not in [".", "#"] do
                desired_room = @rooms[pod]
                other_pods_in_room = Enum.at(levels, desired_room) |> Enum.count(fn p -> p != pod && p != "." end)
                available = find_available_rooms(hallway, index)
                # IO.inspect({pod, other_pods_in_room}, label: "other_pods_in_room")
                if other_pods_in_room == 0 && desired_room in available do
                  move_from_hallway(pod, index, desired_room, {hallway, levels, score})
                else
                  {hallway, levels, score}
                end
              else
                {hallway, levels, score}
              end
            end)
          if result == {hallway, levels, score} do
            {:halt, result}
          else
            # IO.inspect("CHANGED")
            {:cont, result}
          end
        end)
      # print({hallway, levels, score}, label: "after hollway")

      {hallway, levels, score} =
        @rooms |> Map.values() |> Enum.reduce({hallway, levels, score}, fn index, {hallway, levels, score} ->
          room = Enum.at(levels, index)
          case first_pod(room) do
            nil -> {hallway, levels, score}
            {depth, pod} ->
              desired_room_index = @rooms[pod]
              desired_room = Enum.at(levels, desired_room_index)
              available = find_available_rooms(hallway, index)

              if desired_room_index != index && desired_room_index in available && all_pods(desired_room, pod) do
                desired_depth = first_room(desired_room)
                move_rooms(pod, {index, depth}, {desired_room_index, desired_depth}, {hallway, levels, score})
              else
                {hallway, levels, score}
              end
          end
          #
          # case room do
          #   [".", ".", ".", "."] -> {hallway, levels, score}
          #   [".", pod] ->
          #     desired_room_index = @rooms[pod]
          #     desired_room = Enum.at(levels, desired_room_index)
          #     available = find_available_rooms(hallway, index)
          #     if desired_room_index != index && desired_room_index in available do
          #       case desired_room do
          #         [".", "."] ->
          #           IO.inspect("move rooms 1")
          #           move_rooms(pod, {index, 1}, {desired_room_index, 1}, {hallway, levels, score})
          #
          #         [".", ^pod] ->
          #           IO.inspect(desired_room, label: "move rooms 2")
          #           move_rooms(pod, {index, 1}, {desired_room_index, 0}, {hallway, levels, score})
          #
          #         _ ->
          #           {hallway, levels, score}
          #       end
          #     else
          #       {hallway, levels, score}
          #     end
          #
          #   [pod, pod2] ->
          #     desired_room_index = @rooms[pod]
          #     desired_room = Enum.at(levels, desired_room_index)
          #     available = find_available_rooms(hallway, index)
          #     if desired_room_index != index && desired_room_index in available do
          #       case desired_room do
          #         [".", "."] ->
          #           IO.inspect("move rooms 3")
          #           move_rooms(pod, {index, 0}, {desired_room_index, 1}, {hallway, levels, score})
          #
          #         [".", ^pod] ->
          #           IO.inspect("move rooms 4")
          #           move_rooms(pod, {index, 0}, {desired_room_index, 0}, {hallway, levels, score})
          #
          #         _ ->
          #           {hallway, levels, score}
          #       end
          #     else
          #       {hallway, levels, score}
          #     end
          # end
        end)

      if !found(levels) do
        2..8//2 |> Enum.reduce({:found, min_score}, fn index, {:found, min_score} ->
          level = Enum.at(levels, index) |> Enum.with_index()
          [{a, a_index}, {b, b_index}, {c, c_index}, {d, d_index}] = level

          result =
            cond do
              a == "." && b == "." && c == "." && d == "." -> nil
              a == "." && b == "." && c == "." && @rooms[d] == index -> nil
              a == "." && b == "." && @rooms[c] == @rooms[d] && @rooms[d] == index -> nil
              a == "." && @rooms[b] == @rooms[c] && @rooms[c] == @rooms[d] && @rooms[d] == index -> nil
              @rooms[a] == @rooms[b] && @rooms[b] == @rooms[c] && @rooms[c] == @rooms[d] && @rooms[d] == index -> nil
              true ->
                cond do
                  a != "." -> {a, a_index}
                  b != "." -> {b, b_index}
                  c != "." -> {c, c_index}
                  true -> {d, d_index}
                end
            end

          result3 =
            if result do
              {pod, pod_index} = result
              hallway
              |> find_available(index)
              |> Enum.reduce({:found, min_score}, fn pos, {:found, min_score} ->
                hallway_spot = Enum.at(hallway, pos)
                {hallway, levels, score} = move_from_level(pod, index, pod_index, pos, hallway, levels, score)
                result2 = go(hallway, levels, score, min_score)
                case result2 do
                  {:found, score} ->
                    min_score = {:found, min(score, min_score)}
                  _ -> {:found, min_score}
                end
              end)
            else
              {:not_found}
            end

          case result3 do
            {:found, score} ->
              min_score = {:found, min(score, min_score)}
            _ -> {:found, min_score}
          end
        end)
      else
        IO.inspect("FOUND: " <> Integer.to_string(score))
        {:found, score}
      end
    end
    end)
  end

  def first_pod([".", ".", ".", "."]), do: nil
  def first_pod([".", ".", ".", pod]), do: {3, pod}
  def first_pod([".", ".", pod, _]), do: {2, pod}
  def first_pod([".", pod, _, _]), do: {1, pod}
  def first_pod([pod, _, _, _]), do: {0, pod}

  def first_room([".", ".", ".", "."]), do: 3
  def first_room([".", ".", ".", pod]), do: 2
  def first_room([".", ".", pod, _]), do: 1
  def first_room([".", pod, _, _]), do: 0
  def first_room([_, _, _, _]), do: nil

  def all_pods(room, pod) do
    Enum.all?(room, fn r -> r == "." || r == pod end)
  end

  def found(lines) do
    Enum.at(lines, 2) == ["A", "A", "A", "A"] &&
      Enum.at(lines, 4) == ["B", "B", "B", "B"] &&
      Enum.at(lines, 6) == ["C", "C", "C", "C"] &&
      Enum.at(lines, 8) == ["D", "D", "D", "D"]
  end

  def find_available(hallway, room_index) do
    before =
      room_index-1..0 |> Enum.reduce_while([], fn p, acc ->
        spot = Enum.at(hallway, p)
        case spot do
          "." -> {:cont, [p | acc]}
          "#" -> {:cont, acc}
          _ -> {:halt, acc}
        end
      end)
    afte =
      room_index+1..(length(hallway) - 1) |> Enum.reduce_while([], fn p, acc ->
        spot = Enum.at(hallway, p)
        case spot do
          "." -> {:cont, [p | acc]}
          "#" -> {:cont, acc}
          _ -> {:halt, acc}
        end
      end)
    before ++ afte
  end

  def find_available_rooms(hallway, room_index) do
    before =
      room_index-1..0 |> Enum.reduce_while([], fn p, acc ->
        spot = Enum.at(hallway, p)
        case spot do
          "." -> {:cont, acc}
          "#" -> {:cont, [p | acc]}
          _ -> {:halt, acc}
        end
      end)
    afte =
      room_index+1..(length(hallway) - 1) |> Enum.reduce_while([], fn p, acc ->
        spot = Enum.at(hallway, p)
        case spot do
          "." -> {:cont, acc}
          "#" -> {:cont, [p | acc]}
          _ -> {:halt, acc}
        end
      end)
    before ++ afte
  end

  def check({hallway, levels, score}, place) do
    invalid = levels |> List.flatten() |> Enum.filter(& &1 != ".") |> Enum.frequencies() |> Map.values() |> Enum.find(fn a -> a > 4 end)
    if invalid do
      IO.inspect({hallway, levels, score}, label: "INVALID #{place}")
      1 = 2
    else
      {hallway, levels, score}
    end
  end

  def print({hallway, levels, score}, label: label) do
    IO.inspect(hallway, label: label)
    IO.inspect(levels)
  end

  def move_from_hallway(pod, hallway_pos, desired_room, {hallway, levels, score}) do
    # IO.inspect("move_from_hallway #{pod}")
    good_pods_in_room = Enum.at(levels, desired_room) |> Enum.count(fn p -> p == pod end)
    steps = abs(desired_room - hallway_pos)
    depth = 4 - good_pods_in_room
    hallway = List.replace_at(hallway, hallway_pos, ".")
    level = Enum.at(levels, desired_room)
    levels = List.replace_at(levels, desired_room, List.replace_at(level, depth - 1, pod))
    score = score + (steps + depth) * @scores[pod]
    # IO.inspect({hallway, levels, score}, label: "after hallway")
    {hallway, levels, score} |> check("move_from_hallway")
  end

  def move_rooms(pod, {from_room_index, from_depth}, {to_room_index, to_depth}, {hallway, levels, score}) do
    from_room = Enum.at(levels, from_room_index)
    to_room = Enum.at(levels, to_room_index)
    from_room = List.replace_at(from_room, from_depth, ".")
    to_room = List.replace_at(to_room, to_depth, pod)

    depth = from_depth + 1 + to_depth + 1
    steps = abs(from_room_index - to_room_index)
    score = score + (depth + steps) * @scores[pod]

    levels =
      levels
      |> List.replace_at(from_room_index, from_room)
      |> List.replace_at(to_room_index, to_room)
    {hallway, levels, score} |> check("move_rooms")
  end

  def move_from_level(pod, level_index, level_depth, hallway_pos, hallway, levels, score) do
    # IO.inspect("move_from_level")
    level = Enum.at(levels, level_index)
    ^pod = Enum.at(level, level_depth)
    levels = List.replace_at(levels, level_index, List.replace_at(level, level_depth, "."))
    steps = level_depth + 1 + abs(hallway_pos - level_index)
    score = score + steps * @scores[pod]
    hallway = List.replace_at(hallway, hallway_pos, pod)
    {hallway, levels, score} |> check("move_from_level")
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
    |> assert(0)
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
