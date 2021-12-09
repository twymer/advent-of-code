defmodule Day09 do
  def load_file do
    File.read!("day09.txt")
    |> String.split("\n", trim: true)
    |> Enum.map(&(String.split(&1, "", trim: true)))
    |> Enum.map(&(Enum.map(&1, fn n -> String.to_integer(n) end)))
  end

  # ******
  # STAR 1
  # ******

  def get_low_points(grid) do
    Enum.reduce(0..Enum.count(grid) - 1, [], fn j, acc ->
      Enum.reduce(0..Enum.count(Enum.at(grid, 0)) - 1, acc, fn i, acc ->
        position =
          grid
          |> Enum.at(j)
          |> Enum.at(i)

        min_adjacent =
          [[i-1, j], [i+1, j], [i, j-1], [i,j+1]]
          |> Enum.reduce(:infinity, fn [x, y], acc ->
            value_at = if x < 0 or y < 0 do
              :infinity
            else
              # Really hacky way to handle accessors out of bounds...
              grid
              |> Enum.at(y, [])
              |> Enum.at(x, :infinity)
            end

            Enum.min([value_at, acc])
          end)

        if position < min_adjacent do
          acc ++ [[i, j]]
        else
          acc
        end
      end)
    end)
  end

  def star1() do
    grid = load_file()

    get_low_points(grid)
    |> Enum.map(fn [x, y] ->
      grid
      |> Enum.at(y)
      |> Enum.at(x)
    end)
    |> Enum.map(&(&1 + 1))
    |> Enum.sum
    |> IO.inspect
  end

  # ******
  # STAR 2
  # ******

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
      # Hacky way to get a default position that's just a barrier (a 9)
      value_at_new_position =
        grid
        |> Enum.at(new_y, [])
        |> Enum.at(new_x, 9)

      if new_x >= 0 and new_y >= 0 and value_at_new_position !== 9 do
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
    |> IO.inspect
    |> Enum.product
    |> IO.inspect
  end
end

Day09.star2()
