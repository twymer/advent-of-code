defmodule Day23 do
  @room_depth 4
  @room_offsets %{a: 2, b: 4, c: 6, d: 8}
  @type_move_costs %{a: 1, b: 10, c: 100, d: 1000}

  # TODO remove duplication
  def legal_hallway_moves(hallway_state, room, :left) do
    Map.get(@room_offsets, room)..0
    |> Enum.reduce_while([], fn hallway_position, acc ->
      cond do
        Map.get(hallway_state, hallway_position) != nil ->
          {:halt, acc}
        hallway_position not in Map.values(@room_offsets) ->
          {:cont, acc ++ [hallway_position]}
        true ->
          {:cont, acc}
      end
    end)
  end
  # TODO remove duplication
  def legal_hallway_moves(hallway_state, room, :right) do
    Map.get(@room_offsets, room)..10
    |> Enum.reduce_while([], fn hallway_position, acc ->
      cond do
        Map.get(hallway_state, hallway_position) != nil ->
          {:halt, acc}
        hallway_position not in Map.values(@room_offsets) ->
          {:cont, acc ++ [hallway_position]}
        true ->
          {:cont, acc}
      end
    end)
  end

  def legal_hallway_moves(state, room) do
    hallway = Map.get(state, :hallway)

    legal_hallway_moves(hallway, room, :left) ++ legal_hallway_moves(hallway, room, :right)
  end

  def legal_room_move?(state, type, hallway_position) do
    room = Map.get(state, type)
    hallway = Map.get(state, :hallway)

    if Enum.all?(room, &(&1 == type)) || Enum.count(room) == 0 do
      hallway_position..Map.get(@room_offsets, type)
      |> Enum.all?(fn step_position ->
        hallway_position == step_position || Map.get(hallway, step_position) == nil
      end)
    else
      false
    end
  end

  def star2() do
    start_state = %{
      hallway: %{ 0 => nil, 1 => nil, 2 => nil, 3 => nil, 4 => nil, 5 => nil, 6 => nil, 7 => nil, 8 => nil, 9 => nil, 10 => nil },
      a: [:c, :d, :d, :b],
      b: [:b, :c, :b, :c],
      c: [:d, :b, :a, :a],
      d: [:d, :a, :c, :a]
    }
    winner_state = %{
      hallway: %{ 0 => nil, 1 => nil, 2 => nil, 3 => nil, 4 => nil, 5 => nil, 6 => nil, 7 => nil, 8 => nil, 9 => nil, 10 => nil },
      a: [:a, :a, :a, :a],
      b: [:b, :b, :b, :b],
      c: [:c, :c, :c, :c],
      d: [:d, :d, :d, :d]
    }

    Stream.iterate(1, &(&1 + 1))
    |> Enum.reduce_while(%{start_state => 0}, fn _, acc ->
      {best, cost} =
        acc
        |> Enum.min_by(fn {_k, v} -> v end)

      if best == winner_state do
        {:halt, cost}
      else
        acc =
          acc
          |> Map.delete(best)

        # Do any room insertions first
        acc =
          best
          |> Map.get(:hallway)
          |> Enum.filter(fn {k, v} ->
            v != nil && legal_room_move?(best, v, k)
          end)
          |> Enum.reduce(acc, fn {mover_position, mover_type}, acc ->
            new_hallway =
              best
              |> Map.get(:hallway)
              |> Map.put(mover_position, nil)

            new_room = [mover_type | Map.get(best, mover_type)]

            move_count = abs(mover_position - Map.get(@room_offsets, mover_type)) + (@room_depth - Enum.count(new_room)) + 1
            new_cost = Map.get(@type_move_costs, mover_type) * move_count + cost
            acc
            |> Map.update(
              best
              |> Map.put(:hallway, new_hallway)
              |> Map.put(mover_type, new_room),
              new_cost,
              fn v -> Enum.min([new_cost, v]) end
            )
          end)

        # Then do any legal hallway moves
        acc =
          [:a, :b, :c, :d]
          |> Enum.reduce(acc, fn room, acc ->
            room_contents = Map.get(best, room)
            if room_contents != [] && !Enum.all?(room_contents, &(&1 == room)) do
              [mover | new_room_contents] = Map.get(best, room)

              best =
                best
                |> Map.put(room, new_room_contents)

              legal_hallway_moves(best, room)
              |> Enum.reduce(acc, fn legal_hallway_position, acc ->
                new_hallway =
                  best
                  |> Map.get(:hallway)
                  |> Map.put(legal_hallway_position, mover)

                best =
                  best
                  |> Map.put(:hallway, new_hallway)

                move_count = abs(legal_hallway_position - Map.get(@room_offsets, room)) + (@room_depth - Enum.count(new_room_contents))
                new_cost = Map.get(@type_move_costs, mover) * move_count + cost

                acc
                |> Map.update(best, new_cost, fn v -> Enum.min([new_cost, v]) end)
              end)
            else
              acc
            end
          end)

          {:cont, acc}
      end
    end)
  end
end

Day23.star2()
|> IO.inspect
