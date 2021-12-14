defmodule Day14 do
  def load_file do
    [start_state_line | instruction_lines] = File.read!("day14.txt")
    |> String.split("\n", trim: true)

    [
      start_state_line
      |> String.split("", trim: true)
      |> Enum.chunk_every(2, 1)
      |> Enum.reduce(%{}, fn chunk, acc ->
        Map.update(acc, chunk, 1, &(&1 + 1))
      end),

      instruction_lines
      |> Enum.map(&(String.split(&1, " -> ", trim: true)))
      |> Enum.map(fn [pair, insertion] -> [String.split(pair, "", trim: true), insertion] end)
    ]
  end

  def do_step(start_state, instructions) do
    instructions
    |> Enum.reduce(%{}, fn [instruction_pair, instruction_insertion], acc ->
      count_to_insert = Map.get(start_state, instruction_pair, 0)

      [left_char, right_char] = instruction_pair
      left_pair = [left_char, instruction_insertion]
      right_pair = [instruction_insertion, right_char]

      acc
      |> Map.update(left_pair, count_to_insert, &(&1 + count_to_insert))
      |> Map.update(right_pair, count_to_insert, &(&1 + count_to_insert))
      |> Map.update(instruction_pair, -count_to_insert, &(&1 - count_to_insert))
    end)
    |> Map.merge(start_state, fn _k, v1, v2 ->
      v1 + v2
    end)
  end

  def score(state) do
    {min, max} = state
    |> Enum.reduce(%{}, fn {k, v}, acc ->
      [left | _] = k
      Map.update(acc, left, v, &(&1 + v))
    end)
    |> Map.values
    |> Enum.min_max

    max - min
  end

  def star2 do
    [start_state, instructions] = load_file()

    1..40
    |> Enum.reduce(start_state, fn _step, acc ->
      do_step(acc, instructions)
    end)
    |> score
    |> IO.inspect
  end
end

Day14.star2()
