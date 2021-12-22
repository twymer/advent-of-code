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
end

Day22.star2
