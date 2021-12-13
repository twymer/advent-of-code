defmodule Day13 do
  def load_file do
    {dots, folds} = File.read!("day13.txt")
                    |> String.split("\n", trim: true)
                    |> Enum.split_while(&(!String.starts_with?(&1, "fold")))

    {
      dots
      |> Enum.map(&(String.split(&1, ",", trim: true)))
      |> Enum.map(&(Enum.map(&1, fn n -> String.to_integer(n) end)))
      |> Enum.reduce(MapSet.new(), fn coords, acc ->
        MapSet.put(acc, coords)
      end),

      folds
      |> Enum.map(&(String.split(&1, " ")))
      |> Enum.map(&(String.split(Enum.at(&1, -1), "=")))
    }
  end

  def max_pos(dots, :x) do
    dots
    |> Enum.map(&(&1 |> Enum.at(0)))
    |> Enum.max
  end

  def max_pos(dots, :y) do
    dots
    |> Enum.map(&(&1 |> Enum.at(1)))
    |> Enum.max
  end

  def print_grid(dots) do
    IO.puts("")
    Enum.each(0..max_pos(dots, :y), fn j ->
      Enum.reduce(0..max_pos(dots, :x), [], fn i, acc ->
        acc ++
          if MapSet.member?(dots, [i, j]) do
            ["#"]
          else
            [" "]
          end
      end)
      |> Enum.join(" ")
      |> IO.puts
    end)
    IO.puts("")

    dots
  end

  def fold(dots, "x", fold_line) do
    dots
    |> Enum.reduce(MapSet.new(), fn [x, y], acc ->
      cond do
        x < fold_line ->
          MapSet.put(acc, [x, y])
        x > fold_line ->
          MapSet.put(acc, [fold_line - (x - fold_line), y])
        true ->
          acc
      end
    end)
  end

  def fold(dots, "y", fold_line) do
    dots
    |> Enum.reduce(MapSet.new(), fn [x, y], acc ->
      cond do
        y < fold_line ->
          MapSet.put(acc, [x, y])
        y > fold_line ->
          MapSet.put(acc, [x, fold_line - (y - fold_line)])
        true ->
          acc
      end
    end)
  end

  def star2 do
    {dots, folds} = load_file()

    folds
    |> Enum.reduce(dots, fn [axis, fold_line], acc ->
      fold(acc, axis, String.to_integer(fold_line))
    end)
    |> print_grid
  end
end

Day13.star2()
