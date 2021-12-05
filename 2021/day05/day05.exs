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

  def coordinates_hit_for_vent([start_point, end_point]) do
    cond do
      start_point.x === end_point.x ->
        Enum.map(start_point.y..end_point.y, fn y -> {start_point.x, y} end)
      start_point.y === end_point.y ->
        Enum.map(start_point.x..end_point.x, fn x -> {x, start_point.y} end)
      true ->
        # This was required for star 2, it's the only change but
        # I haven't updated code to leave separate paths (yet?)
        Enum.zip(start_point.x..end_point.x, start_point.y..end_point.y)
    end
  end

  def star2() do
    parse_file()
    |> Enum.reduce([], fn vent, acc ->
      acc ++ coordinates_hit_for_vent(vent)
    end)
    |> Enum.frequencies
    |> Enum.count(fn {_, v} -> v > 1 end)
    |> IO.inspect
  end
end

Day05.star2()
