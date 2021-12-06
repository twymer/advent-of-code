defmodule Day06 do
  def seed_fish() do
    File.read!("day06.txt")
    |> String.trim
    |> String.split(",")
    |> Enum.map(&String.to_integer/1)
  end

  def star1() do
    days = 80

    Enum.reduce(0..days - 1, seed_fish(), fn _, acc ->
      [normal_fish, birthing_fish] =
        acc
        |> Enum.map(&(&1 - 1))
        |> Enum.split_with(&(&1 >= 0))
        |> Tuple.to_list

      normal_fish ++
        List.duplicate(6, Enum.count(birthing_fish)) ++
        List.duplicate(8, Enum.count(birthing_fish))
    end)
    |> Enum.count
    |> IO.inspect
  end

  def star2() do
    days = 256

    fish_counts = Enum.frequencies(seed_fish())

    Enum.reduce(0..days - 1, fish_counts, fn _, acc ->
      birthing_fish = Map.get(acc, 0, 0)

      Enum.reduce(1..8, acc, fn day, acc ->
        Map.put(
          acc,
          day - 1,
          Map.get(acc, day, 0)
        )
      end)
      |> Map.update(6, birthing_fish, &(&1 + birthing_fish))
      |> Map.put(8, birthing_fish)
    end)
    |> Map.values
    |> Enum.sum
    |> IO.inspect
  end
end

# Day06.star1
Day06.star2
