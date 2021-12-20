defmodule Day20 do
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

  def min_index(:x, grid) do
    grid
    |> Map.keys
    |> Enum.map(&(&1 |> Kernel.elem(0)))
    |> Enum.min
  end

  def min_index(:y, grid) do
    grid
    |> Map.keys
    |> Enum.map(&(&1 |> Kernel.elem(1)))
    |> Enum.min
  end

  def print_grid(grid) do
    IO.puts("")
    Enum.each((min_index(:y, grid) - 5)..(max_index(:y, grid) + 5), fn row ->
      Enum.reduce((min_index(:x, grid) - 5)..(max_index(:x, grid) + 5), [], fn column, acc ->
        acc ++ [Map.get(grid, {column, row}, " ")]
      end)
      |> Enum.join("")
      |> IO.puts
    end)
    IO.puts("")

    grid
  end

  def load_file do
    file =
      File.read!("day20.txt")
      |> String.split("\n", trim: true)

    enhancement_algo =
      file
      |> Enum.at(0)
      |> String.split("", trim: true)
      |> Enum.with_index
      |> Enum.map(fn {k, v} -> {v, k} end)
      |> Map.new

    grid =
      file
      |> Enum.slice(1..-1)
      |> Enum.map(&(String.split(&1, "", trim: true)))

    input_image =
      Enum.reduce(0..(Enum.count(grid) - 1), %{}, fn j, acc ->
        Enum.reduce(0..(Enum.count(Enum.at(grid, 0)) - 1), acc, fn i, acc ->
          Map.put(
            acc,
            {i, j},
            grid
            |> Enum.at(j)
            |> Enum.at(i)
          )
        end)
      end)

    {input_image, enhancement_algo}
  end

  def convert_pixel(input_image, enhancement_algo, {x, y}, step) do
    Enum.reduce(-1..1, "", fn j, acc ->
      Enum.reduce(-1..1, acc, fn i, acc ->
        if Map.get(input_image, {x+i, y+j}, get_infinity(enhancement_algo, step)) === "#" do
          acc <> "1"
        else
          acc <> "0"
        end
      end)
    end)
    |> String.to_integer(2)
    |> then(&(Map.get(enhancement_algo, &1)))
  end

  def get_infinity(enhancement_algo, step) do
    # NOTE this encodes some bias that infinity starts out as unlit pixels.
    # If the start state had lit pixels stretching outwards this would break.
    cond do
      Map.get(enhancement_algo, 0) == "." ->
        "."
      rem(step, 2) == 1 ->
        Map.get(enhancement_algo, 0)
      true ->
        Map.get(enhancement_algo, 511)
    end
  end

  def enhance(input_image, enhancement_algo, step) do
    offset = 1
    x_range = (min_index(:x, input_image) - offset)..(max_index(:x, input_image) + offset)
    y_range = (min_index(:y, input_image) - offset)..(max_index(:y, input_image) + offset)

    Enum.reduce(y_range, %{}, fn y, acc ->
      Enum.reduce(x_range, acc, fn x, acc ->
        input_image
        |> convert_pixel(enhancement_algo, {x, y}, step)
        |> then(&(Map.put(acc, {x, y}, &1)))
      end)
    end)
  end

  def star1 do
    {input_image, enhancement_algo} = load_file()

    0..2
    |> Enum.reduce(input_image, fn step, acc ->
      IO.puts "Step #{step}"

      acc
      |> enhance(enhancement_algo, step)
    end)
    |> print_grid
    |> Map.values
    |> Enum.frequencies
    |> Map.get("#")
    |> IO.inspect
  end

  def star2 do
    {input_image, enhancement_algo} = load_file()

    0..49
    |> Enum.reduce(input_image, fn step, acc ->
      IO.puts "Step #{step}"

      acc
      |> enhance(enhancement_algo, step)
    end)
    |> print_grid
    |> Map.values
    |> Enum.frequencies
    |> Map.get("#")
    |> IO.inspect
  end
end

Day20.star2()
