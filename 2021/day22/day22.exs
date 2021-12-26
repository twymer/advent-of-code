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
      {
        command,
        %{
          x_min: x_min,
          x_max: x_max + 1,
          y_min: y_min,
          y_max: y_max + 1,
          z_min: z_min,
          z_max: z_max + 1
        }
      }
    end)
  end

  def split_merge(base, splitter) do
    shards = []

    # Extending right
    {shard, splitter} = if splitter.x_min > base.x_min && splitter.x_min < base.x_max && splitter.x_max > base.x_max do
      IO.puts "right"
      {
        %{
          x_min: base.x_max,
          x_max: splitter.x_max,
          y_min: splitter.y_min,
          y_max: splitter.y_max,
          z_min: splitter.z_min,
          z_max: splitter.z_max
        } |> IO.inspect,
        %{
          x_min: splitter.x_min,
          x_max: base.x_max,
          y_min: splitter.y_min,
          y_max: splitter.y_max,
          z_min: splitter.z_min,
          z_max: splitter.z_max
        }
      }
    else
      {nil, splitter}
    end
    shards = shards ++ [shard]

    # Extending left
    {shard, splitter} = if splitter.x_max > base.x_min && splitter.x_max < base.x_max && splitter.x_min < base.x_min do
      IO.puts "left"
      {
        %{
          x_min: splitter.x_min,
          x_max: base.x_min,
          y_min: splitter.y_min,
          y_max: splitter.y_max,
          z_min: splitter.z_min,
          z_max: splitter.z_max
        } |> IO.inspect,
        %{
          x_min: base.x_min,
          x_max: splitter.x_max,
          y_min: splitter.y_min,
          y_max: splitter.y_max,
          z_min: splitter.z_min,
          z_max: splitter.z_max

        }
      }
    else
      {nil, splitter}
    end
    shards = shards ++ [shard]

    # Extending down
    {shard, splitter} = if splitter.y_min > base.y_min && splitter.y_min < base.y_max && splitter.y_max > base.y_max do
      IO.puts "down"
      {
        %{
          x_min: splitter.x_min,
          x_max: splitter.x_max,
          y_min: base.y_max,
          y_max: splitter.y_max,
          z_min: splitter.z_min,
          z_max: splitter.z_max
        } |> IO.inspect,
        %{
          x_min: splitter.x_min,
          x_max: splitter.x_max,
          y_min: splitter.y_min,
          y_max: base.y_max,
          z_min: splitter.z_min,
          z_max: splitter.z_max
        }
      }
    else
      {nil, splitter}
    end
    shards = shards ++ [shard]

    # Extending up
    {shard, splitter} = if splitter.y_max > base.y_min && splitter.y_max < base.y_max && splitter.y_min < base.y_min do
      IO.puts "up"
      {
        %{
          x_min: splitter.x_min,
          x_max: splitter.x_max,
          y_min: splitter.y_min,
          y_max: base.y_min,
          z_min: splitter.z_min,
          z_max: splitter.z_max
        } |> IO.inspect,
        %{
          x_min: splitter.x_min,
          x_max: splitter.x_max,
          y_min: base.y_min,
          y_max: splitter.y_max,
          z_min: splitter.z_min,
          z_max: splitter.z_max
        }
      }
    else
      {nil, splitter}
    end
    shards = shards ++ [shard]

    # Extending in
    {shard, splitter} = if splitter.z_min > base.z_min && splitter.z_min < base.z_max && splitter.z_max > base.z_max do
      IO.puts "in"
      base |> IO.inspect
      splitter |> IO.inspect
      {
        %{
          x_min: splitter.x_min,
          x_max: splitter.x_max,
          y_min: splitter.y_min,
          y_max: splitter.y_max,
          z_min: base.z_max,
          z_max: splitter.z_max
        } |> IO.inspect,
        %{
          x_min: splitter.x_min,
          x_max: splitter.x_max,
          y_min: splitter.y_min,
          y_max: splitter.y_max,
          z_min: splitter.z_min,
          z_max: base.z_max
        }
      }
    else
      {nil, splitter}
    end
    shards = shards ++ [shard]

    # Extending out
    {shard, splitter} = if splitter.z_max > base.z_min && splitter.z_max < base.z_max && splitter.z_min < base.z_min do
      IO.puts "out"
      {
        %{
          x_min: splitter.x_min,
          x_max: splitter.x_max,
          y_min: splitter.y_min,
          y_max: splitter.y_max,
          z_min: splitter.z_min,
          z_max: base.z_min
        } |> IO.inspect,
        %{
          x_min: splitter.x_min,
          x_max: splitter.x_max,
          y_min: splitter.y_min,
          y_max: splitter.y_max,
          z_min: base.z_min,
          z_max: splitter.z_max
        }
      }
    else
      {nil, splitter}
    end
    shards = shards ++ [shard]

    IO.puts ""
    IO.puts "final splitter"
    IO.inspect(splitter)

    shards
    |> Enum.filter(&(&1))
  end

  def volume(cuboids) do
    cuboids
    |> Enum.reduce(0, fn cuboid, acc ->
      acc + ((cuboid.x_max - cuboid.x_min) * (cuboid.y_max - cuboid.y_min) * (cuboid.z_max - cuboid.z_min))
    end)
  end

  def process_instruction(cuboids, command, cuboid) do
    new_cuboids =
      Enum.reduce(cuboids, [], fn old_cuboid, acc ->
        intersection_results = split_merge(cuboid, old_cuboid)

        # If there were no intersections, preserve the old one
        acc = acc ++ if intersection_results == [] do
          [old_cuboid]
        else
          intersection_results
        end
      end)

    # If it's an on command then we want to add the cuboid itself
    new_cuboids ++ if command == "on" do
      [cuboid]
    else
      []
    end
  end

  def star2 do
    parse_file()
    |> Enum.with_index
    |> Enum.reduce([], fn {{command, cuboid}, index}, acc ->
      IO.puts ""
      IO.puts "Step: #{index + 1}"
      process_instruction(acc, command, cuboid)
    end)
    |> volume
    |> IO.inspect
  end
end

Day22.star2()


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
# Day22.split_merge(right, left)
# |> Day22.volume
# |> IO.inspect

# left = %{x_min: 0, x_max: 4, y_min: 0, y_max: 4, z_min: 0, z_max: 1}
# right = %{x_min: 1, x_max: 3, y_min: 3, y_max: 5, z_min: 0, z_max: 1}
# # 4
# Day22.split_merge(left, right)
# |> IO.inspect
# |> Day22.volume
# |> IO.inspect
