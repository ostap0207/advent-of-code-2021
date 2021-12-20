defmodule Solution do
  def part1(input) do
    lines = parse_input(input)
    len = length(lines)

    transformed = %{0 => Enum.at(lines, 0)}
    {transformed, _} = transform(lines, transformed, %{}, [0])

    transformed
    |> Enum.concat(Enum.at(lines, 0))
    |> Enum.uniq()
    |> Enum.count()
  end

  def part2(input) do
    lines = parse_input(input)
    len = length(lines)

    transformed = %{0 => Enum.at(lines, 0)}
    {_, scanners} = transform(lines, transformed, %{}, [0])

    scanners = [{0, 0, 0} | scanners |> Map.values()]
    dist = for s <- scanners, s2 <- scanners, s != s2 do
      manhatahn(s, s2)
    end
    |> Enum.max()
  end

  def transform(lines, transformed, sensors, visited) do
    {result, sensors} =
      transformed |> Enum.reduce({%{}, sensors}, fn {pos, transformed_beacons}, {acc, sensors} ->
        lines |> Enum.with_index() |> Enum.reduce({acc, sensors}, fn {beacons1, j}, {acc, sensors} ->
          if j not in visited do
            case find_overlapping(lines, transformed_beacons, beacons1) do
              {transformed, diff} ->
                {Map.put(acc, j, transformed), Map.put(sensors, j, diff)}
              _ ->
                {acc, sensors}
            end
          else
            {acc, sensors}
          end
        end)
      end)

      if Enum.empty?(result) do
        {transformed |> Map.values() |> List.flatten(), sensors}
      else
        {new_transformed, sensors} = transform(lines, result, sensors, Map.keys(result) ++ visited)
        {(transformed |> Map.values() |> List.flatten()) ++ new_transformed, sensors}
      end
    end

  def find_overlapping(scanners, beacons1, beacons2) do
    0..47 |> Enum.reduce_while([], fn n, acc ->
      {diff, max} =
        for b1 <- beacons1, b2 <-beacons2 do
          minus(b1, rotate(b2, n))
        end
        |> Enum.frequencies()
        |> Enum.max_by(fn {a, b} -> b end)

      if max >= 12 do
        transformed = beacons2 |> Enum.map(fn p -> add(rotate(p, n), diff) end)
        {:halt, {transformed, diff}}
      else
        {:cont, acc}
      end
    end)
  end

  def manhatahn({a, b, c}, {a2, b2, c2}) do
    abs(a - a2) + abs(b - b2) + abs(c - c2)
  end

  def rotate({x, y, z}, 0), do: {x, y, z}
  def rotate({x, y, z}, 1), do: {y, -1 * x , z}
  def rotate({x, y, z}, 2), do: {-1 * x, -1 * y, z}
  def rotate({x, y, z}, 3), do: {-1 * y, x, z}
  def rotate({x, y, z}, 4), do: {x, y, -1 * z}
  def rotate({x, y, z}, 5), do: {y, -1 * x , -1 * z}
  def rotate({x, y, z}, 6), do: {-1 * x, -1 * y, -1 * z}
  def rotate({x, y, z}, 7), do: {-1 * y, x, -1 * z}

  def rotate({x, y, z}, n) when n < 16, do: rotate({z, y, x}, n - 8)
  def rotate({x, y, z}, n) when n < 24, do: rotate({x, z, y}, n - 16)
  def rotate({x, y, z}, n) when n < 32, do: rotate({y, z, x}, n - 24)
  def rotate({x, y, z}, n) when n < 40, do: rotate({z, x, y}, n - 32)
  def rotate({x, y, z}, n) when n < 48, do: rotate({y, x, z}, n - 40)
  #
  # def rotate({x, y, z}, 8), do: rotate({z, y, x}, 0)
  # def rotate({x, y, z}, 9), do: rotate({z, y, x}, 1)
  # def rotate({x, y, z}, 10), do: rotate({z, y, x}, 2)
  # def rotate({x, y, z}, 11), do: rotate({z, y, x}, 3)
  # def rotate({x, y, z}, 12), do: rotate({z, y, x}, 4)
  # def rotate({x, y, z}, 13), do: rotate({z, y, x}, 5)
  # def rotate({x, y, z}, 14), do: rotate({z, y, x}, 6)
  # def rotate({x, y, z}, 15), do: rotate({z, y, x}, 7)
  #
  # def rotate({x, y, z}, 16), do: rotate({x, z, y}, 0)
  # def rotate({x, y, z}, 17), do: rotate({x, z, y}, 1)
  # def rotate({x, y, z}, 18), do: rotate({x, z, y}, 2)
  # def rotate({x, y, z}, 19), do: rotate({x, z, y}, 3)
  # def rotate({x, y, z}, 20), do: rotate({x, z, y}, 4)
  # def rotate({x, y, z}, 21), do: rotate({x, z, y}, 5)
  # def rotate({x, y, z}, 22), do: rotate({x, z, y}, 6)
  # def rotate({x, y, z}, 23), do: rotate({x, z, y}, 7)
  #
  # def rotate({x, y, z}, 24), do: rotate({y, z, x}, 0)
  # def rotate({x, y, z}, 25), do: rotate({y, z, x}, 1)
  # def rotate({x, y, z}, 26), do: rotate({y, z, x}, 2)
  # def rotate({x, y, z}, 27), do: rotate({y, z, x}, 3)
  # def rotate({x, y, z}, 28), do: rotate({y, z, x}, 4)
  # def rotate({x, y, z}, 29), do: rotate({y, z, x}, 5)
  # def rotate({x, y, z}, 30), do: rotate({y, z, x}, 6)
  # def rotate({x, y, z}, 31), do: rotate({y, z, x}, 7)
  #
  # def rotate({x, y, z}, 32), do: rotate({z, x, y}, 0)
  # def rotate({x, y, z}, 33), do: rotate({z, x, y}, 1)
  # def rotate({x, y, z}, 34), do: rotate({z, x, y}, 2)
  # def rotate({x, y, z}, 35), do: rotate({z, x, y}, 3)
  # def rotate({x, y, z}, 36), do: rotate({z, x, y}, 4)
  # def rotate({x, y, z}, 37), do: rotate({z, x, y}, 5)
  # def rotate({x, y, z}, 38), do: rotate({z, x, y}, 6)
  # def rotate({x, y, z}, 39), do: rotate({z, x, y}, 7)
  #
  # def rotate({x, y, z}, 40), do: rotate({y, x, z}, 0)
  # def rotate({x, y, z}, 41), do: rotate({y, x, z}, 1)
  # def rotate({x, y, z}, 42), do: rotate({y, x, z}, 2)
  # def rotate({x, y, z}, 43), do: rotate({y, x, z}, 3)
  # def rotate({x, y, z}, 44), do: rotate({y, x, z}, 4)
  # def rotate({x, y, z}, 45), do: rotate({y, x, z}, 5)
  # def rotate({x, y, z}, 46), do: rotate({y, x, z}, 6)
  # def rotate({x, y, z}, 47), do: rotate({y, x, z}, 7)

  # def rotate({x, y, z}, n), do: {x, y, z}

  def minus({a, b, c}, {a2, b2, c2}) do
    {a - a2, b - b2, c - c2}
  end

  def add({a, b, c}, {a2, b2, c2}) do
    {a + a2, b + b2, c + c2}
  end

  def parse_input(input) do
    input |> String.split("\n\n", trim: true) |> Enum.map(fn scanners ->
      [_ | rest] = String.split(scanners, "\n", trim: true)
      rest |> Enum.map(fn s ->
        String.split(s, ",", trim: true) |> Enum.map(&String.to_integer/1) |> List.to_tuple()
      end)
    end)
  end
end

defmodule Test do
  @input """
  --- scanner 0 ---
  404,-588,-901
  528,-643,409
  -838,591,734
  390,-675,-793
  -537,-823,-458
  -485,-357,347
  -345,-311,381
  -661,-816,-575
  -876,649,763
  -618,-824,-621
  553,345,-567
  474,580,667
  -447,-329,318
  -584,868,-557
  544,-627,-890
  564,392,-477
  455,729,728
  -892,524,684
  -689,845,-530
  423,-701,434
  7,-33,-71
  630,319,-379
  443,580,662
  -789,900,-551
  459,-707,401

  --- scanner 1 ---
  686,422,578
  605,423,415
  515,917,-361
  -336,658,858
  95,138,22
  -476,619,847
  -340,-569,-846
  567,-361,727
  -460,603,-452
  669,-402,600
  729,430,532
  -500,-761,534
  -322,571,750
  -466,-666,-811
  -429,-592,574
  -355,545,-477
  703,-491,-529
  -328,-685,520
  413,935,-424
  -391,539,-444
  586,-435,557
  -364,-763,-893
  807,-499,-711
  755,-354,-619
  553,889,-390

  --- scanner 2 ---
  649,640,665
  682,-795,504
  -784,533,-524
  -644,584,-595
  -588,-843,648
  -30,6,44
  -674,560,763
  500,723,-460
  609,671,-379
  -555,-800,653
  -675,-892,-343
  697,-426,-610
  578,704,681
  493,664,-388
  -671,-858,530
  -667,343,800
  571,-461,-707
  -138,-166,112
  -889,563,-600
  646,-828,498
  640,759,510
  -630,509,768
  -681,-892,-333
  673,-379,-804
  -742,-814,-386
  577,-820,562

  --- scanner 3 ---
  -589,542,597
  605,-692,669
  -500,565,-823
  -660,373,557
  -458,-679,-417
  -488,449,543
  -626,468,-788
  338,-750,-386
  528,-832,-391
  562,-778,733
  -938,-730,414
  543,643,-506
  -524,371,-870
  407,773,750
  -104,29,83
  378,-903,-323
  -778,-728,485
  426,699,580
  -438,-605,-362
  -469,-447,-387
  509,732,623
  647,635,-688
  -868,-804,481
  614,-800,639
  595,780,-596

  --- scanner 4 ---
  727,592,562
  -293,-554,779
  441,611,-461
  -714,465,-776
  -743,427,-804
  -660,-479,-426
  832,-632,460
  927,-485,-438
  408,393,-506
  466,436,-512
  110,16,151
  -258,-428,682
  -393,719,612
  -211,-452,876
  808,-476,-593
  -575,615,604
  -485,667,467
  -680,325,-822
  -627,-443,-432
  872,-547,-609
  833,512,582
  807,604,487
  839,-516,451
  891,-625,532
  -652,-548,-490
  30,-46,-14
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
    |> assert(79)
  end

  def part2 do
    @input
    |> Solution.part2()
    |> assert(3621)
  end
end

Test.part1()
IO.inspect(Solution.part1(File.read!("input.txt")), label: "Part 1")
#
Test.part2()
IO.inspect(Solution.part2(File.read!("input.txt")), label: "Part 2")
