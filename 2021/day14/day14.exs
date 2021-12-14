defmodule Day14 do
  def load_file do
    File.read!("day14.txt")
    |> String.split("\n", trim: true)
    |> Enum.map(&(String.split(&1, " -> ", trim: true)))
  end

  def do_step(start_state, instructions) do
    instructions
    |> Enum.reduce(%{}, fn [instruction_pair, instruction_insertion], acc ->
      [left_char, right_char] = String.split(instruction_pair, "", trim: true)

      count_to_insert = Map.get(start_state, [left_char, right_char], 0)

      left_pair = [left_char, instruction_insertion]
      right_pair = [instruction_insertion, right_char]

      acc
      |> Map.update(left_pair, count_to_insert, &(&1 + count_to_insert))
      |> Map.update(right_pair, count_to_insert, &(&1 + count_to_insert))
      |> Map.update([left_char, right_char], -count_to_insert, &(&1 - count_to_insert))
    end)
    |> Map.merge(start_state, fn _k, v1, v2 ->
      v1 + v2
    end)
  end

  def star2 do
    start_state =
      String.split("VHCKBFOVCHHKOHBPNCKO", "", trim: true)
      |> Enum.chunk_every(2, 1)
      |> Enum.reduce(%{}, fn chunk, acc ->
        Map.update(acc, chunk, 1, &(&1 + 1))
      end)

    instructions = load_file()

    steps = 40

    results =
      1..steps
      |> Enum.reduce(start_state, fn step, acc ->
        IO.puts("Step #{step}")
        do_step(acc, instructions)
      end)
      |> Enum.reduce(%{}, fn {k, v}, acc ->
        [left | _] = k
        Map.update(acc, left, v, &(&1 + v))
      end)
      |> IO.inspect

    min =
      results
      |> Enum.min_by(&elem(&1, 1))

    max =
      results
      |> Enum.max_by(&elem(&1, 1))

    Kernel.elem(max, 1) - Kernel.elem(min, 1)
    |> IO.inspect
  end
end

Day14.star2()
