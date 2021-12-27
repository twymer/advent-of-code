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
    {shard, splitter} = if base.x_max in splitter.x_min+1..splitter.x_max-1 do
      IO.puts "right"
      IO.inspect base
      IO.inspect splitter
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
    {shard, splitter} = if base.x_min in splitter.x_min+1..splitter.x_max-1 do
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
    {shard, splitter} = if base.y_max in splitter.y_min+1..splitter.y_max-1 do
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
    {shard, splitter} = if base.y_min in splitter.y_min+1..splitter.y_max-1 do
      IO.puts "up"
      IO.inspect base
      IO.inspect splitter
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
    {shard, splitter} = if base.z_max in splitter.z_min+1..splitter.z_max-1 do
      IO.puts "in"
      IO.inspect base
      IO.inspect splitter
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
    {shard, _splitter} = if base.z_min in splitter.z_min+1..splitter.z_max-1 do
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

    shards
    |> Enum.filter(&(&1))
  end

  def volume(cuboids) do
    cuboids
    |> Enum.reduce(0, fn cuboid, acc ->
      acc + ((cuboid.x_max - cuboid.x_min) * (cuboid.y_max - cuboid.y_min) * (cuboid.z_max - cuboid.z_min))
    end)
  end

  # TODO LOL at this
  def intersects?(old, new) do
    (
      (new.x_max in old.x_min..old.x_max || new.x_min in old.x_min..old.x_max) &&
      (new.y_max in old.y_min..old.y_max || new.y_min in old.y_min..old.y_max) &&
      (new.z_max in old.z_min..old.z_max || new.z_min in old.z_min..old.z_max)
    ) ||
      (old.x_max in new.x_min..new.x_max || old.x_min in new.x_min..new.x_max) &&
      (old.y_max in new.y_min..new.y_max || old.y_min in new.y_min..new.y_max) &&
      (old.z_max in new.z_min..new.z_max || old.z_min in new.z_min..new.z_max)
  end

  def process_instruction(cuboids, command, cuboid) do
    new_cuboids =
      Enum.reduce(cuboids, [], fn old_cuboid, acc ->
        intersection_results =
          if intersects?(old_cuboid, cuboid) do
            IO.puts ""
            IO.puts "intersect"
            old_cuboid |> IO.inspect
            cuboid |> IO.inspect
            IO.puts ""
            split_merge(cuboid, old_cuboid)
          else
            IO.puts ""
            IO.puts "NON intersect"
            old_cuboid |> IO.inspect
            cuboid |> IO.inspect
            IO.puts ""
            [old_cuboid]
          end

        acc ++ intersection_results
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
      if index == 3 do
        IO.puts ""
        cuboid |> IO.inspect
        acc |> IO.inspect
        IO.puts ""
      end
      process_instruction(acc, command, cuboid)
    end)
    |> IO.inspect
    |> volume
    |> IO.inspect
  end
end

Day22.star2()

# 3d version of 1
# No changes on Z, so just tests existing code with expanded volumes
# left = %{x_min: 0, x_max: 4, y_min: 0, y_max: 4, z_min: 0, z_max: 4}
# right = %{x_min: 2, x_max: 6, y_min: 2, y_max: 6, z_min: 0, z_max: 4}
# Day22.split_merge(right, left)
# |> Day22.volume
# |> IO.inspect
# Day22.split_merge(left, right)
# |> Day22.volume
# |> IO.inspect

# Fully offset cuboids
# I think 56 is the right answer here..
# left = %{x_min: 0, x_max: 4, y_min: 0, y_max: 4, z_min: 0, z_max: 4}
# right = %{x_min: 2, x_max: 6, y_min: 2, y_max: 6, z_min: 2, z_max: 6}
# Day22.split_merge(left, right)
# |> Day22.volume
# |> IO.inspect
# Day22.split_merge(right, left)
# |> Day22.volume
# |> IO.inspect

# left = %{x_min: 0, x_max: 4, y_min: 0, y_max: 4, z_min: 0, z_max: 1}
# right = %{x_min: 1, x_max: 3, y_min: 3, y_max: 5, z_min: 0, z_max: 1}
# # 4
# Day22.split_merge(right, left)
# # Day22.split_merge(left, right)
# |> IO.inspect
# |> Day22.volume
# |> IO.inspect

# left = %{x_min: 0, x_max: 4, y_min: 0, y_max: 4, z_min: 0, z_max: 1}
# right = %{x_min: 5, x_max: 8, y_min: 5, y_max: 8, z_min: 2, z_max: 3}
# # no intersect
# Day22.intersects?(left, right)
# |> IO.inspect

# left = %{x_min: 0, x_max: 4, y_min: 0, y_max: 4, z_min: 0, z_max: 1}
# right = %{x_min: 1, x_max: 3, y_min: 1, y_max: 3, z_min: 0, z_max: 1}
# # 5
# Day22.split_merge(right, left)
# |> IO.inspect
# |> Day22.volume
# |> IO.inspect
# Day22.split_merge(left, right)
# |> IO.inspect
# |> Day22.volume
# |> IO.inspect
