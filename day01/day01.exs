defmodule Day01 do
  # STAR 1

  def star1() do
    {:ok, contents} = File.read("day01.txt")

    contents
    |> String.split("\n", trim: true)
    |> Enum.map(fn row -> String.to_integer(row) end)
    |> Enum.reduce(%{last: nil, count: 0}, fn x, acc ->
      if x > acc.last && acc.last != nil do
        %{last: x, count: acc.count + 1}
      else
        %{last: x, count: acc.count}
      end
    end)
    |> IO.inspect
  end

  # STAR 2

  def star2() do
    {:ok, contents} = File.read("day01.txt")

    numbers = contents
    |> String.split("\n", trim: true)
    |> Enum.map(fn row -> String.to_integer(row) end)

    Enum.reduce_while(numbers, %{position: 0, count: 0}, fn _, acc ->
      first = Enum.slice(numbers, acc.position, 3)
      second = Enum.slice(numbers, acc.position + 1, 3)

      cond do
        Enum.count(second) < 3 ->
          {:halt, acc}
        Enum.sum(first) < Enum.sum(second) ->
          {:cont, %{position: acc.position + 1, count: acc.count + 1}}
        true ->
          {:cont, %{position: acc.position + 1, count: acc.count}}
      end
    end)
    |> IO.inspect
  end

  def star2_refactor() do
    {:ok, contents} = File.read("day01.txt")

    numbers = contents
    |> String.split("\n", trim: true)
    |> Enum.map(fn row -> String.to_integer(row) end)
    |> Enum.chunk_every(3, 1, :discard)
    |> Enum.map(fn triplet -> Enum.sum(triplet) end)
    |> Enum.chunk_every(2, 1, :discard)
    |> Enum.count(fn [left, right] -> right > left end)
    |> IO.inspect
  end
end

# Day01.star1()
Day01.star2_refactor()
