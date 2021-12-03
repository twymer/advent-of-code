defmodule Day03 do
  # STAR 1

  def star1() do
    File.read!("../day03/day03.txt")
    |> String.split("\n", trim: true)
    |> Enum.map(fn line -> String.split(line, "", trim: true) end)
    |> Enum.zip
    |> Enum.map(fn column -> Tuple.to_list(column) end)
    |> Enum.map(fn column -> Enum.frequencies(column) end)
    |> Enum.reduce(%{gamma: [], epsilon: []}, fn counts, acc -> 
      if Map.get(counts, "0") > Map.get(counts, "1") do
        %{gamma: acc.gamma ++ ["0"], epsilon: acc.epsilon ++ ["1"]}
      else
        %{gamma: acc.gamma ++ ["1"], epsilon: acc.epsilon ++ ["0"]}
      end
    end)
    |> Enum.map(fn {k, v} ->
      {
        k,
        List.to_integer(List.to_charlist(v), 2)
      }
    end)
    |> Enum.into(%{})
    |> IO.inspect
    |> Map.values
    |> Enum.product
  end

  # STAR 2

  def compare(left, right, calculation_type) do
    case calculation_type do
      :oxygen -> left > right
      :co2 -> left <= right
    end
  end

  def compute(numbers, position, calculation_type) do
    filter_digit = numbers
    |> Enum.map(fn line -> String.split(line, "", trim: true) end)
    |> Enum.zip()
    |> Enum.map(&Tuple.to_list(&1))
    |> Enum.at(position)
    |> Enum.frequencies()
    |> Map.to_list()
    |> Enum.map(&Tuple.to_list(&1))
    |> Enum.sort(&(compare(Enum.at(&1, 1), Enum.at(&2, 1), calculation_type)))
    |> Enum.at(0)
    |> Enum.at(0)

    matches = numbers
    |> Enum.filter(fn number ->
      String.at(number, position) === filter_digit
    end)

    if Enum.count(matches) === 1 do
      Enum.at(matches, 0)
    else
      compute(matches, position + 1, calculation_type)
    end
  end

  def star2() do
    numbers =
      File.read!("../day03/day03.txt")
      |> String.split("\n", trim: true)

    oxygen = compute(numbers, 0, :oxygen)
    |> IO.inspect()
    |> String.to_integer(2)

    co2 = compute(numbers, 0, :co2)
    |> IO.inspect()
    |> String.to_integer(2)

    oxygen * co2
    |> IO.inspect
  end
end

Day03.star2()
