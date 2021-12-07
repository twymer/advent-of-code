defmodule Day07 do
  def parse_file() do
    File.read!("day07.txt")
    |> String.trim
    |> String.split(",")
    |> Enum.map(&String.to_integer/1)
  end

  def star1() do
    input = parse_file()

    [min, max] = [Enum.min(input), Enum.max(input)]

    Enum.reduce(min..max, %{best_position: nil, best_cost: :infinity}, fn trial_position, acc ->
      fuel_cost = Enum.reduce(input, 0, fn crab_position, acc ->
        acc + Kernel.abs(crab_position - trial_position)
      end)

      if fuel_cost < acc.best_cost do
        %{best_cost: fuel_cost, best_position: trial_position}
      else
        acc
      end
    end)
    |> IO.inspect
  end

  def calculate_fuel(pos1, pos2) do
    Enum.reduce(0..Kernel.abs(pos1 - pos2), 0, fn i, acc -> 
      acc + i
    end)
  end

  def star2() do
    input = parse_file()

    [min, max] = [Enum.min(input), Enum.max(input)]

    Enum.reduce(min..max, %{best_position: nil, best_cost: :infinity}, fn trial_position, acc ->
      fuel_cost = Enum.reduce(input, 0, fn crab_position, acc ->
        distance = Kernel.abs(crab_position - trial_position)
        cost = distance * (distance + 1) / 2
        acc + cost
      end)

      if fuel_cost < acc.best_cost do
        %{best_cost: fuel_cost, best_position: trial_position}
      else
        acc
      end
    end)
    |> IO.inspect
  end
end

# Day07.star1()
Day07.star2()
