defmodule Day05 do
  def parse_file() do
    File.read!("day05.txt")
    |> String.split("\n", trim: true)
    |> Enum.map(&String.split(&1, " -> ", trim: true))
    |> Enum.map(&Enum.map(&1, fn coord ->
      [:x, :y]
      |> Enum.zip(
        String.split(coord, ",")
        |> Enum.map(fn x -> String.to_integer(x) end)
      )
      |> Map.new
    end))

  end

  def coordinates_hit_for_vent(pair) do
    pair
    |> Enum.sort

    [one, two] = pair

    cond do
      one.x === two.x ->
        Enum.map(one.y..two.y, fn y -> {one.x, y} end)
      one.y === two.y ->
        Enum.map(one.x..two.x, fn x -> {x, one.y} end)
      true ->
        # I assume this is star 2, but skip for now
        []
    end
  end

  def star1() do
    parse_file()
    |> Enum.reduce([], fn vent, acc ->
      acc ++ coordinates_hit_for_vent(vent)
    end)
    |> Enum.frequencies
    |> Enum.count(fn {_, v} -> v > 1 end)
    |> IO.inspect
  end
end

Day05.star1()
