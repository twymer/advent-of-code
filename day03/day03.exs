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

  def oxygen(base_numbers) do
    base_numbers
    |> Enum.map(fn line -> String.split(line, "", trim: true) end)
    |> Enum.zip
    |> Enum.map(fn column -> Tuple.to_list(column) end)
    |> Enum.map(fn column -> Enum.frequencies(column) end)
    |> Enum.reduce_while(%{numbers: base_numbers, position: 0}, fn _, acc ->
      counts = acc.numbers
      |> Enum.map(fn number -> String.at(number, acc.position) end)
      |> Enum.frequencies

      digit = if Map.get(counts, "1") >= Map.get(counts, "0") do
        "1"
      else
        "0"
      end

      result_numbers = acc.numbers
      |> Enum.filter(fn number ->
        String.at(number, acc.position) === digit
      end)

      if Enum.count(result_numbers) === 1 do
        {:halt, %{numbers: result_numbers, position: acc.position}}
      else
        {:cont, %{numbers: result_numbers, position: acc.position + 1}}
      end
    end)
    |> Map.get(:numbers)
    |> Enum.at(0)
  end

  def co2(base_numbers) do
    base_numbers
    |> Enum.map(fn line -> String.split(line, "", trim: true) end)
    |> Enum.zip
    |> Enum.map(fn column -> Tuple.to_list(column) end)
    |> Enum.map(fn column -> Enum.frequencies(column) end)
    |> Enum.reduce_while(%{numbers: base_numbers, position: 0}, fn _, acc ->
      counts = acc.numbers
      |> Enum.map(fn number -> String.at(number, acc.position) end)
      |> Enum.frequencies

      digit = if Map.get(counts, "1") >= Map.get(counts, "0") do
        "0"
      else
        "1"
      end

      result_numbers = acc.numbers
      |> Enum.filter(fn number ->
        String.at(number, acc.position) === digit
      end)

      if Enum.count(result_numbers) === 1 do
        {:halt, %{numbers: result_numbers, position: acc.position}}
      else
        {:cont, %{numbers: result_numbers, position: acc.position + 1}}
      end
    end)
    |> Map.get(:numbers)
    |> Enum.at(0)
  end

  def star2() do
    base_numbers = File.read!("../day03/day03.txt")
    |> String.split("\n", trim: true)

    o = oxygen(base_numbers)
    |> IO.inspect
    |> String.to_integer(2)

    c = co2(base_numbers)
    |> IO.inspect
    |> String.to_integer(2)

    o * c
    |> IO.inspect
  end
end

Day03.star2()
