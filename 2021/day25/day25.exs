defmodule Day25 do
  def max_index(:x, grid) do
    grid
    |> Map.keys
    |> Enum.map(&(&1 |> Kernel.elem(0)))
    |> Enum.max
  end

  def max_index(:y, grid) do
    grid
    |> Map.keys
    |> Enum.map(&(&1 |> Kernel.elem(1)))
    |> Enum.max
  end

  def print_grid(grid) do
    IO.puts("")
    Enum.each(0..max_index(:y, grid), fn row ->
      Enum.reduce(0..max_index(:x, grid), [], fn column, acc ->
        acc ++ [Map.get(grid, {column, row}, " ")]
      end)
      |> Enum.join("")
      |> IO.puts
    end)
    IO.puts("")

    grid
  end

  def load_file do
    grid =
      File.read!("day25.txt")
      |> String.split("\n", trim: true)
      |> Enum.map(&(String.split(&1, "", trim: true)))

    height = Enum.count(grid) - 1
    width = Enum.count(Enum.at(grid, 0)) - 1

    grid_map =
      Enum.reduce(0..height, %{}, fn j, acc ->
        Enum.reduce(0..width, acc, fn i, acc ->
          Map.put(
            acc,
            {i, j},
            grid
            |> Enum.at(j)
            |> Enum.at(i)
          )
        end)
      end)

    {grid_map, width, height}
  end

  def star1 do
    {grid, width, height} = load_file()

    Stream.iterate(1, &(&1 + 1))
    |> Enum.reduce_while(grid, fn step, last_step_grid ->
      if rem(step, 100) == 0 do
        IO.puts "Step #{step}"
      end

      mid_step_grid =
        Enum.reduce(0..height, last_step_grid, fn j, acc ->
          Enum.reduce(0..width, acc, fn i, acc ->
            cond do
              Map.get(last_step_grid, {i, j}) == ">" &&
              Map.get(last_step_grid, {i+1, j}, nil) == "." ->
                acc
                |> Map.put({i, j}, ".")
                |> Map.put({i + 1, j}, ">")
              Map.get(last_step_grid, {i, j}) == ">" &&
              i == width &&
              Map.get(last_step_grid, {0, j}, nil) == "." ->
                acc
                |> Map.put({i, j}, ".")
                |> Map.put({0, j}, ">")
            true ->
              Map.put_new(acc, {i, j}, Map.get(last_step_grid, {i, j}))
            end
          end)
        end)

      final_grid =
        Enum.reduce(0..height, mid_step_grid, fn j, acc ->
          Enum.reduce(0..width, acc, fn i, acc ->
            cond do
              Map.get(mid_step_grid, {i, j}) == "v" &&
              Map.get(mid_step_grid, {i, j + 1}, nil) == "." ->
                acc
                |> Map.put({i, j}, ".")
                |> Map.put({i, j + 1}, "v")
              Map.get(mid_step_grid, {i, j}) == "v" &&
              j == height &&
              Map.get(mid_step_grid, {i, 0}, nil) == "." ->
                acc
                |> Map.put({i, j}, ".")
                |> Map.put({i, 0}, "v")
              true ->
                Map.put_new(acc, {i, j}, Map.get(mid_step_grid, {i, j}))
            end
          end)
        end)

      if final_grid === last_step_grid do
        {:halt, step}
      else
        {:cont, final_grid}
      end
    end)
  end
end

Day25.star1
|> IO.inspect
