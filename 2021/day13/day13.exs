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

  def print_grid(dots) do
    max_x =
      dots
      |> Enum.map(&(&1 |> Enum.at(0)))
      |> Enum.max

    max_y =
      dots
      |> Enum.map(&(&1 |> Enum.at(1)))
      |> Enum.max

    IO.puts("")
    Enum.each(0..max_y, fn j ->
      Enum.reduce(0..max_x, [], fn i, acc ->
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

  # TODO These are very not DRY, need to refactor to be able to do the
  # fold in a single function (or, at very least, only have minor logic
  # that isn't in a shared function here..)
  def fold(dots, "x", fold_line) do
    Enum.reduce(1..fold_line, MapSet.new(), fn offset, acc ->
      0..max_pos(dots, :y)
      |> Enum.reduce(MapSet.new(), fn y, acc ->
        acc =
          if MapSet.member?(dots, [fold_line - offset, y]) do
            MapSet.put(acc, [fold_line - offset, y])
          else
            acc
          end

        if MapSet.member?(dots, [fold_line + offset, y]) do
          MapSet.put(acc, [fold_line - offset, y])
        else
          acc
        end
      end)
      |> MapSet.union(acc)
    end)
  end

  # TODO These are very not DRY, need to refactor to be able to do the
  # fold in a single function (or, at very least, only have minor logic
  # that isn't in a shared function here..)
  def fold(dots, "y", fold_line) do
    Enum.reduce(1..fold_line, MapSet.new(), fn offset, acc ->
      0..max_pos(dots, :x)
      |> Enum.reduce(MapSet.new(), fn x, acc ->
        acc =
          if MapSet.member?(dots, [x, fold_line - offset]) do
            MapSet.put(acc, [x, fold_line - offset])
          else
            acc
          end

        if MapSet.member?(dots, [x, fold_line + offset]) do
          MapSet.put(acc, [x, fold_line - offset])
        else
          acc
        end
      end)
      |> MapSet.union(acc)
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
