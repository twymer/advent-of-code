defmodule Day17 do
  def load_file do
    # lol
    target = %{
      x: %{ min: 201, max: 230},
      y: %{ min: -99, max: -65}
    }
    start = %{x: 0, y: 0}

    {target, start}
  end

  def advance_probe(velocity, position, target, max_y) do
    new_pos = %{
      x: position.x + velocity.x,
      y: position.y + velocity.y
    }

    new_x_velocity = cond do
      velocity.x > 0 -> velocity.x - 1
      velocity.x < 0 -> velocity.x + 1
      true -> 0
    end

    new_velocity = %{
      x: new_x_velocity,
      y: velocity.y - 1
    }

    new_max_y = if !max_y || new_pos.y > max_y do
      new_pos.y
    else
      max_y
    end

    cond do
      new_pos.x in target.x.min..target.x.max && new_pos.y in target.y.min..target.y.max ->
        new_max_y
      new_pos.x > target.x.max ->
        nil
      new_pos.y < target.y.min ->
        nil
      true ->
        advance_probe(new_velocity, new_pos, target, new_max_y)
    end
  end

  def launch_probe(velocity, start, target) do
    advance_probe(velocity, start, target, nil)
  end

  def star1 do
    {target, start} = load_file()

    0..200
    |> Enum.reduce(-10000, fn y, acc ->
      0..200
      |> Enum.reduce(acc, fn x, acc ->
        launch_hit_max = launch_probe(%{x: x, y: y}, start, target)

        if launch_hit_max && launch_hit_max > acc do
          launch_hit_max
        else
          acc
        end
      end)
    end)
    |> IO.inspect
  end

  def star2 do
    {target, start} = load_file()

    -100..300
    |> Enum.reduce(0, fn y, acc ->
      0..target.x.max
      |> Enum.reduce(acc, fn x, acc ->
        launch_hit_max = launch_probe(%{x: x, y: y}, start, target)

        if launch_hit_max do
          acc + 1
        else
          acc
        end
      end)
    end)
    |> IO.inspect
  end
end

Day17.star2()
