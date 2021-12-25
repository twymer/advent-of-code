defmodule Day22 do
  def parse_file do
    line_regex = ~r/(\w+) x=(-?\d+)..(-?\d+),y=(-?\d+)..(-?\d+),z=(-?\d+)..(-?\d+)/
    File.read!("day22.txt")
    |> then(&(Regex.scan(line_regex, &1)))
    |> Enum.map(fn match_data ->
      match_data
      |> Enum.with_index
      |> Enum.map(fn {val, i} ->
        if i < 2 do
          val
        else
          String.to_integer(val)
        end
      end)
    end)
    |> Enum.reject(fn [_, _ | values] ->
      Enum.any?(values, &(&1 > 50 || &1 < -50))
    end)
    |> Enum.map(fn [_, command, x_min, x_max, y_min, y_max, z_min, z_max] ->
      %{
        command: command,
        x_min: x_min,
        x_max: x_max,
        y_min: y_min,
        y_max: y_max,
        z_min: z_min,
        z_max: z_max
      }
    end)
  end

  def star2 do
    parse_file()
    |> Enum.with_index
    |> Enum.reduce(%{}, fn {instruction, index}, acc ->
      IO.puts "Step: #{index + 1}"
      Enum.reduce(instruction.x_min..instruction.x_max, acc, fn i, acc ->
        Enum.reduce(instruction.y_min..instruction.y_max, acc, fn j, acc ->
          Enum.reduce(instruction.z_min..instruction.z_max, acc, fn k, acc ->
            Map.put(acc, {i, j, k}, (if instruction.command == "on", do: 1, else: 0))
          end)
        end)
      end)
    end)
    |> Map.values
    |> Enum.frequencies
    |> Map.get(1)
    |> IO.inspect
  end

  def split_merge(base, splitter) do
    results = []

    # Extending right
    # Greedy over y
    temp = if splitter.x_min > base.x_min && splitter.x_min < base.x_max do
      %{x_min: base.x_max, x_max: splitter.x_max, y_min: splitter.y_min, y_max: splitter.y_max}
    end
    results = results ++ [temp]

    # Extending left
    # Greedy over y
    temp = if splitter.x_min < base.x_min && splitter.x_min < base.x_max do
      %{x_min: splitter.x_min, x_max: base.x_min, y_min: splitter.y_min, y_max: splitter.y_max}
    end
    results = results ++ [temp]

    # Extending down
    temp = if base.y_min < splitter.y_min && base.y_max > splitter.y_min do
      %{x_min: splitter.x_min, x_max: base.x_max, y_min: base.y_max, y_max: splitter.y_max}
    end
    results = results ++ [temp]

    # Extending up
    temp = if splitter.y_max > base.y_min && splitter.y_max < base.y_max do
      %{x_min: base.x_min, x_max: splitter.x_max, y_min: splitter.y_min, y_max: base.y_min}
    end
    results = results ++ [temp]

    # Extending in

    # Extending out

    results
  end

  def volume(cuboids) do
    cuboids
    |> Enum.reduce(0, fn cuboid, acc ->
      acc + ((cuboid.x_max - cuboid.x_min) * (cuboid.y_max - cuboid.y_min))
    end)
  end
end


# left = %{x_min: 0, x_max: 4, y_min: 0, y_max: 4}
# right = %{x_min: 2, x_max: 6, y_min: 2, y_max: 6}
# 1
# Day22.split_merge(left, right)
# Day22.split_merge(right, left)

# 2
# left = %{x_min: 0, x_max: 2, y_min: 0, y_max: 2}
# right = %{x_min: 0, x_max: 2, y_min: 1, y_max: 3}
# Day22.split_merge(left, right)
# Day22.split_merge(right, left)

# 3
# left = %{x_min: 0, x_max: 2, y_min: 0, y_max: 2}
# right = %{x_min: 1, x_max: 3, y_min: 0, y_max: 2}
# Day22.split_merge(left, right)
# Day22.split_merge(right, left)


# No changes on Z, so just tests existing code with expanded volumes
# left = %{x_min: 0, x_max: 0, y_min: 0, y_max: 4, z_min: 0, z_max: 4}
# right = %{x_min: 2, x_max: 6, y_min: 2, y_max: 6, z_min: 0, z_max: 4}

# Fully offset cuboids
# left = %{x_min: 0, x_max: 0, y_min: 0, y_max: 4, z_min: 0, z_max: 4}
# right = %{x_min: 2, x_max: 6, y_min: 2, y_max: 6, z_min: 2, z_max: 6}

Day22.split_merge(left, right)
|> Enum.filter(&(&1))
|> IO.inspect
|> Day22.volume
|> IO.inspect
# Day22.star2
