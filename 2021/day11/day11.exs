defmodule Day11 do
  @board_width 10
  @board_height 10

  def load_file do
    grid = File.read!("day11.txt")
    |> String.split("\n", trim: true)
    |> Enum.map(&(String.split(&1, "", trim: true)))
    |> Enum.map(&(Enum.map(&1, fn n -> String.to_integer(n) end)))

    # Storing things in a map with [x, y] keys seemed easier for the rest of
    # the problem.
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

  def print_grid(grid) do
    IO.puts("")
    Enum.each(0..@board_width - 1, fn row ->
      Enum.reduce(0..@board_height - 1, [], fn column, acc ->
        acc ++ [Map.get(grid, [column, row])]
      end)
      |> Enum.join(" ")
      |> IO.puts
    end)
    IO.puts("")

    grid
  end

  def increase_octopus_energy(grid, octopus) do
    if Map.has_key?(grid, octopus) do
      new_value = Map.get(grid, octopus, 0) + 1
      grid = Map.put(grid, octopus, new_value)

      if new_value === 10 do
        Enum.reduce(-1..1, grid, fn i, acc ->
          Enum.reduce(-1..1, acc, fn j, acc ->
            if [i, j] !== [0, 0] do
              acc
              |> increase_octopus_energy([Enum.at(octopus, 0) + i, Enum.at(octopus, 1) + j])
              |> Map.merge(acc, fn _k, v1, v2 -> Enum.max([v1, v2]) end)
            else
              acc
            end
          end)
        end)
      else
        grid
      end
    else
      grid
    end
  end

  def simulate_step(grid) do
    grid
    |> Enum.reduce(grid, fn {octopus, _}, acc ->
      increase_octopus_energy(acc, octopus)
    end)
    |> Enum.reduce(grid, fn {octopus, energy}, acc ->
      if energy > 9 do
        Map.put(acc, octopus, 0)
      else
        Map.put(acc, octopus, energy)
      end
    end)
  end

  def star2 do
    initial_grid = load_file()

    Stream.iterate(1, &(&1 + 1))
    |> Enum.reduce_while(initial_grid, fn current_step, acc ->
      grid = simulate_step(acc)

      flashed_count =
        grid
        |> Map.values
        |> Enum.count(&(&1 === 0))

      if flashed_count === @board_width * @board_height do
        {:halt, current_step}
      else
        {:cont, grid}
      end
    end)
    |> IO.inspect
  end
end

Day11.star2()
