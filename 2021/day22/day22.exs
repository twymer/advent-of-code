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
    # TODO
    # NOTE
    # you can greatly simplify these by letting everything be greedy but removing
    # from the block you're splitting before going to the next step
    results = []

    # Extending right
    # Greedy over y and z
    temp = if splitter.x_min > base.x_min && splitter.x_min < base.x_max do
      IO.puts "right"
      %{
        x_min: base.x_max,
        x_max: splitter.x_max,
        y_min: splitter.y_min,
        y_max: splitter.y_max,
        z_min: splitter.z_min,
        z_max: splitter.z_max
      }
    end
    results = results ++ [temp]

    # Extending left
    # Greedy over y and z
    temp = if splitter.x_min < base.x_min && splitter.x_min < base.x_max do
      IO.puts "left"
      %{
        x_min: splitter.x_min,
        x_max: base.x_min,
        y_min: splitter.y_min,
        y_max: splitter.y_max,
        z_min: splitter.z_min,
        z_max: splitter.z_max
      }
    end
    results = results ++ [temp]

    # Extending down
    temp = if splitter.y_min > base.y_min && splitter.y_min < base.y_max do
      IO.puts "down"
      %{
        x_min: splitter.x_min,
        x_max: base.x_max,
        y_min: base.y_max,
        y_max: splitter.y_max,
        z_min: splitter.z_min,
        z_max: splitter.z_max
      }
    end
    results = results ++ [temp]

    # Extending up
    temp = if splitter.y_max > base.y_min && splitter.y_max < base.y_max do
      IO.puts "up"
      %{
        x_min: base.x_min,
        x_max: splitter.x_max,
        y_min: splitter.y_min,
        y_max: base.y_min,
        z_min: splitter.z_min,
        z_max: splitter.z_max
      }
    end
    results = results ++ [temp]

    # Extending in
    # The least greedy of the 3
    temp = if splitter.z_min > base.z_min && splitter.z_min < base.z_max do
      IO.puts "in"
      %{
        x_min: splitter.x_min,
        x_max: splitter.x_max,
        y_min: splitter.y_min,
        y_max: splitter.y_max,
        z_min: base.z_max,
        z_max: splitter.z_max
      }
    end
    results = results ++ [temp]

    # Extending out
    # The least greedy of the 3
    temp = if splitter.z_max > base.z_min && splitter.z_max < base.z_max do
      IO.puts "out"
      %{
        x_min: splitter.x_max,
        x_max: base.x_max,
        y_min: splitter.y_max,
        y_max: base.y_max,
        z_min: splitter.z_min,
        z_max: base.z_min
      }
    end
    results = results ++ [temp]

    results
  end

  def volume(cuboids) do
    cuboids
    |> Enum.reduce(0, fn cuboid, acc ->
      acc + ((cuboid.x_max - cuboid.x_min) * (cuboid.y_max - cuboid.y_min) * (cuboid.z_max - cuboid.z_min))
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


# 3d version of 1
# No changes on Z, so just tests existing code with expanded volumes
# left = %{x_min: 0, x_max: 4, y_min: 0, y_max: 4, z_min: 0, z_max: 4}
# right = %{x_min: 2, x_max: 6, y_min: 2, y_max: 6, z_min: 0, z_max: 4}

# Fully offset cuboids
# I think 56 is the right answer here..
# left = %{x_min: 0, x_max: 4, y_min: 0, y_max: 4, z_min: 0, z_max: 4}
# right = %{x_min: 2, x_max: 6, y_min: 2, y_max: 6, z_min: 2, z_max: 6}
# Day22.split_merge(left, right)


# Some test data from the assignment
# on x=10..12,y=10..12,z=10..12
# on x=11..13,y=11..13,z=11..13
left = %{x_min: 10, x_max: 13, y_min: 10, y_max: 13, z_min: 10, z_max: 13}
right = %{x_min: 11, x_max: 14, y_min: 11, y_max: 14, z_min: 11, z_max: 14}

IO.puts "one"
Day22.volume([left])
|> IO.inspect
IO.puts ""

IO.puts "two"
Day22.split_merge(left, right)
|> Enum.filter(&(&1))
|> IO.inspect
|> tap(&(Enum.map(&1, fn foo -> Day22.volume([foo]) |> IO.inspect end)))
|> Day22.volume
|> IO.inspect
# Day22.star2
