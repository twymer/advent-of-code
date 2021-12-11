defmodule Day11 do
  def load_file do
    grid = File.read!("day11.txt")
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

  def print_grid(grid) do
    IO.puts("")
    Enum.each(0..9, fn row ->
      Enum.reduce(0..9, [], fn column, acc ->
        acc ++ [Map.get(grid, [column, row])]
      end)
      |> Enum.join(" ")
      |> IO.puts
    end)
    IO.puts("")

    grid
  end

  def let_that_octopus_shine(grid, octopus) do
    # TODO there has to be a better way to prevent this out of bounds..
    if Map.has_key?(grid, octopus) do
      new_value = Map.get(grid, octopus, 0) + 1
      grid = Map.put(grid, octopus, new_value)

      if new_value === 10 do
        Enum.reduce(-1..1, grid, fn i, acc ->
          Enum.reduce(-1..1, acc, fn j, acc ->
            if [i, j] !== [0, 0] do
              grid_after_neighbor = let_that_octopus_shine(
                acc,
                [Enum.at(octopus, 0) + i, Enum.at(octopus, 1) + j]
              )
              Map.merge(acc, grid_after_neighbor, fn _k, v1, v2 ->
                Enum.max([v1, v2])
              end)
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

  def step(grid) do
    grid
    |> Enum.reduce(grid, fn {octopus, _}, acc ->
      acc
      |> let_that_octopus_shine(octopus)
    end)
    |> Enum.reduce(%{grid: %{}, shiners: []}, fn {octopus, energy}, acc ->
      if energy > 9 do
        %{
          grid: Map.put(acc.grid, octopus, 0),
          shiners: acc.shiners ++ [octopus]
        }
      else
        %{
          grid: Map.put(acc.grid, octopus, energy),
          shiners: acc.shiners
        }
      end
    end)
  end

  def star1 do
    initial_grid = load_file()
    days = 100

    final_state = Enum.reduce(0..days - 1, %{grid: initial_grid, shiners: 0}, fn _, acc ->
      results = step(acc.grid)
      results[:grid] |> print_grid
      %{
        grid: results[:grid],
        shiners: acc.shiners + Enum.count(results[:shiners])
      }
    end)

    IO.puts(final_state[:shiners])
  end
end

Day11.star1()
