defmodule Day15 do
  @tile_count 5

  def load_file do
    grid =
      File.read!("day15.txt")
      |> String.split("\n", trim: true)
      |> Enum.map(&(String.split(&1, "", trim: true)))
      |> Enum.map(&(Enum.map(&1, fn n -> String.to_integer(n) end)))

    Enum.reduce(0..(Enum.count(grid) - 1), %{}, fn j, acc ->
      Enum.reduce(0..(Enum.count(Enum.at(grid, 0)) - 1), acc, fn i, acc ->
        Map.put(
          acc,
          {i, j},
          grid
          |> Enum.at(j)
          |> Enum.at(i)
        )
      end)
    end)
    |> Map.put({0, 0}, 0)
  end

  def load_file_2 do
    grid = File.read!("day15.txt")
           |> String.split("\n", trim: true)
           |> Enum.map(&(String.split(&1, "", trim: true)))
           |> Enum.map(&(Enum.map(&1, fn n -> String.to_integer(n) end)))

    base_width = Enum.count(Enum.at(grid, 0))
    base_height = Enum.count(grid)

    Enum.reduce(0..@tile_count - 1, %{}, fn tile_j, acc ->
      Enum.reduce(0..(Enum.count(grid) - 1), acc, fn j, acc ->
        Enum.reduce(0..@tile_count - 1, acc, fn tile_i, acc ->
          Enum.reduce(0..(Enum.count(Enum.at(grid, 0)) - 1), acc, fn i, acc ->
            base_risk =
              grid
              |> Enum.at(j)
              |> Enum.at(i)

            Map.put(
              acc,
              {i + base_width * tile_i, j + base_height * tile_j},
              rem(base_risk + tile_i + tile_j - 1, 9) + 1
            )
          end)
        end)
      end)
    end)
    |> Map.put({0, 0}, 0)
  end

  def max_index(:x, grid) do
    grid
    |> Map.keys
    |> Enum.map(&(&1 |> Kernel.elem(0)))
    |> Enum.max
  end

  def max_index(:y, grid) do
    grid
    |> Map.keys
    |> Enum.map(&(&1 |> Kernel.elem(1)))
    |> Enum.max
  end

  def print_grid(grid) do
    IO.puts("")
    Enum.each(0..max_index(:y, grid), fn row ->
      Enum.reduce(0..max_index(:x, grid), [], fn column, acc ->
        acc ++ [Map.get(grid, {column, row})]
      end)
      |> Enum.join("")
      |> IO.puts
    end)
    IO.puts("")

    grid
  end

  def neighbors(position, max_position) do
    [{-1, 0}, {1, 0}, {0, -1}, {0, 1}]
    |> Enum.reduce([], fn offset, acc ->
      x = Kernel.elem(position, 0) + Kernel.elem(offset, 0)
      y = Kernel.elem(position, 1) + Kernel.elem(offset, 1)

      {max_x, max_y} = max_position

      if x <= max_x && y <= max_y && x >= 0 && y >= 0 do
        acc ++ [{x, y}]
      else
        acc
      end
    end)
  end

  def calculate_all_costs(risk_levels) do
    max_x = max_index(:x, risk_levels)
    max_y = max_index(:y, risk_levels)

    Stream.iterate(0, &(&1 + 1))
    |> Enum.reduce_while(
      %{
        positions: [{max_x, max_y}],
        costs: %{{max_x, max_y} => Map.get(risk_levels, {max_x, max_y})}
      }, fn _, acc ->

      if Enum.count(acc.positions) === 0 do
        { :halt, acc.costs }
      else
        [current_pos | remaining_pos] = acc.positions
        current_pos_cost = Map.get(acc.costs, current_pos)

        {
          :cont,
          current_pos
          |> neighbors({max_x, max_y})
          |> Enum.reduce(%{costs: acc.costs, positions: remaining_pos}, fn neighbor, acc ->
            neighbor_risk = Map.get(risk_levels, neighbor)
            previous_neighbor_cost = Map.get(acc.costs, neighbor, :infinity)
            current_neighbor_cost = neighbor_risk + current_pos_cost

            if current_neighbor_cost < previous_neighbor_cost do
              %{
                costs: Map.put(acc.costs, neighbor, current_neighbor_cost),
                positions: acc.positions ++ [neighbor]
              }
            else
              %{ costs: acc.costs, positions: acc.positions }
            end
          end)
        }
      end
    end)
  end

  def star1 do
    load_file()
    |> calculate_all_costs
    |> Map.get({0, 0})
    |> IO.inspect
  end

  def star2 do
    load_file_2()
    |> calculate_all_costs
    |> Map.get({0, 0})
    |> IO.inspect
  end
end

Day15.star2()
