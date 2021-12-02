defmodule Day02 do
  # STAR 1

  def star1() do
    {:ok, contents} = File.read("day02.txt")

    contents
    |> String.split("\n", trim: true)
    |> Enum.map(fn row -> String.split(row) end)
    |> Enum.map(fn [command, distance] -> [command, String.to_integer(distance)] end)
    |> Enum.reduce(%{horizontal: 0, depth: 0}, fn [command, distance], acc ->
      case command do
        "up" ->
          %{horizontal: acc.horizontal, depth: acc.depth - distance}
        "down" ->
          %{horizontal: acc.horizontal, depth: acc.depth + distance}
        "forward" ->
          %{horizontal: acc.horizontal + distance, depth: acc.depth}
      end
    end)
    |> IO.inspect
  end

  # STAR 2

  def star2() do
    {:ok, contents} = File.read("day02.txt")

    contents
    |> String.split("\n", trim: true)
    |> Enum.map(fn row -> String.split(row) end)
    |> Enum.map(fn [command, distance] -> [command, String.to_integer(distance)] end)
    |> Enum.reduce(%{aim: 0, horizontal: 0, depth: 0}, fn [command, distance], acc ->
      case command do
        "up" ->
          %{aim: acc.aim - distance, horizontal: acc.horizontal, depth: acc.depth}
        "down" ->
          %{aim: acc.aim + distance, horizontal: acc.horizontal, depth: acc.depth}
        "forward" ->
          %{aim: acc.aim, horizontal: acc.horizontal + distance, depth: acc.depth + acc.aim * distance}
      end
    end)
    |> IO.inspect
  end
end

# result = Day02.star1()
# IO.inspect(result.horizontal * result.depth)

result = Day02.star2()
IO.inspect(result.horizontal * result.depth)
