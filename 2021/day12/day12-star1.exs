defmodule Day12 do
  def load_file do
    File.read!("day12.txt")
    |> String.split("\n", trim: true)
    |> Enum.reduce(%{}, fn pair, acc ->
      # TODO Can I use .then to chain this too somehow?
      [left, right] = String.split(pair, "-")

      acc
      |> Map.update(
        left,
        [right],
        fn existing -> existing ++ [right] end
      )
      |> Map.update(
        right,
        [left],
        fn existing -> existing ++ [left] end
      )
    end)
  end

  def small_cave?(position) do
    String.downcase(position) === position && !Enum.member?(["start", "end"], position)
  end

  def find_paths(cave_map, position, current_path \\ []) do
    cond do
      position === "end" ->
        IO.inspect(current_path ++ [position])
        # current_path ++ [position]
        1
      position === "start" && Enum.count(current_path) > 0 ->
        # []
        0
      small_cave?(position) && Enum.member?(current_path, position) ->
        # []
        0
      true ->
        cave_map
        |> Map.get(position)
        |> Enum.reduce(0, fn connected_position, acc ->
          # TODO Can I use .then to chain all of this?
          paths =
            cave_map
            |> find_paths(connected_position, current_path ++ [position])

          acc + paths
        end)
    end
  end

  def star1 do
    load_file()
    |> find_paths("start")
    |> IO.inspect
  end
end

Day12.star1()
