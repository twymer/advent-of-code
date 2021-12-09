defmodule Day09 do
  def load_file do
    grid = File.read!("day09.txt")
    |> String.split("\n", trim: true)
    |> Enum.map(&(String.split(&1, "", trim: true)))
    |> Enum.map(&(Enum.map(&1, fn n -> String.to_integer(n) end)))

    # Storing things in a map with [x, y] keys seemed easier for the rest of
    # the problem. After getting this passing I'm not convinced it's "better"
    # but it definitely cleans some things up.
    Enum.reduce(0..(Enum.count(grid) - 1), %{}, fn j, acc ->
      Enum.reduce(0..(Enum.count(Enum.at(grid, 0)) - 1), acc, fn i, acc ->
        Map.put(
          acc,
          [i, j],
          grid
          |> Enum.at(j)
          |> Enum.at(i)
        )
      end)
    end)
  end

  def get_low_points(grid) do
    Enum.reduce(grid, [], fn {[i, j], center_value}, acc ->
      min_adjacent =
        [[i-1, j], [i+1, j], [i, j-1], [i,j+1]]
        |> Enum.reduce(:infinity, fn [x, y], acc ->
          Enum.min([Map.get(grid, [x, y], :infinity), acc])
        end)

      if center_value < min_adjacent do
        acc ++ [[i, j]]
      else
        acc
      end
    end)
  end

  def find_valley(grid, [x, y]) do
    # NOTE: there's a better way to handle default arguments but was having
    # some issues with that and this also lets me start with a singular point
    # instead of an array of one
    find_valley(grid, [[x, y]], [])
  end

  def find_valley(_, [], seen_points) do
    # Base case, given it's not a tree search we're only hitting this when
    # our queue of points to process has been emptied and we are done, so we
    # don't have to merge this on return
    seen_points
  end

  def find_valley(grid, points, seen_points) do
    [point | remaining_points] = points

    if Enum.member?(seen_points, point) do
      find_valley(grid, remaining_points, seen_points)
    else
      find_valley(
        grid,
        remaining_points ++ valley_adjacents(grid, point),
        seen_points ++ [point]
      )
    end
  end

  def valley_adjacents(grid, [x, y]) do
    [[x-1, y], [x+1, y], [x, y-1], [x,y+1]]
    |> Enum.reduce([], fn [new_x, new_y], acc ->
      # Treat anything we can't find as a barrier
      value_at_new_position = Map.get(grid, [new_x, new_y], 9)

      if value_at_new_position !== 9 do
        acc ++ [[new_x, new_y]]
      else
        acc
      end
    end)
  end

  def star2() do
    grid = load_file()

    get_low_points(grid)
    |> Enum.map(fn low_point ->
      find_valley(grid, low_point)
    end)
    |> Enum.map(&(Enum.count(&1)))
    |> Enum.sort
    |> Enum.reverse
    |> Enum.take(3)
    |> Enum.product
    |> IO.inspect
  end
end

Day09.star2()
