depths_str = "input.txt" |> File.read!() |> String.split("\n") |> Enum.filter(& &1 != "")
depths = depths_str |> Enum.map(&Integer.parse/1) |> Enum.map(fn {num, _} -> num end)

# Part 1
prev_depths = [Enum.at(depths, 0) | depths]
pairs = Enum.zip(prev_depths, depths)

pairs
|> Enum.filter(fn {prev, curr} -> curr > prev end)
|> length()
|> IO.puts()

# Part 2

summed_depth = Enum.chunk_every(depths, 3, 1) |> Enum.map(&Enum.sum/1)
IO.inspect(summed_depth)
prev_summed_depth = [Enum.at(summed_depth, 0) | summed_depth]
pairs = Enum.zip(prev_summed_depth, summed_depth)

pairs
|> Enum.filter(fn {prev, curr} -> curr > prev end)
|> length()
|> IO.puts()
