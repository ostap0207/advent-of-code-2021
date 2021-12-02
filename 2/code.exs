lines = "input.txt" |> File.read!() |> String.split("\n") |> Enum.filter(& &1 != "")

defmodule Helpers do
  def int(str) do
    {num, _} = Integer.parse(str)
    num
  end
end


# Part 1
{h, v} =
  lines
  |> Enum.reduce({0, 0}, fn
    "forward " <> steps, {h, v} ->
      {h + Helpers.int(steps), v}
    "down " <> steps, {h, v} ->
      {h, v + Helpers.int(steps)}
    "up " <> steps, {h, v} ->
      {h, v - Helpers.int(steps)}
  end)

IO.inspect(h * v)


# Part 2
{h, v, _} =
  lines
  |> Enum.reduce({0, 0, 0}, fn
    "forward " <> steps, {h, v, a} ->
      {h + Helpers.int(steps), v + a * Helpers.int(steps), a}
    "down " <> steps, {h, v, a} ->
      {h, v, a + Helpers.int(steps)}
    "up " <> steps, {h, v, a} ->
      {h, v, a - Helpers.int(steps)}
  end)

IO.inspect(h * v)
