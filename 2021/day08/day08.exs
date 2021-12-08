defmodule Day08 do
  def star1() do
    File.read!("day08.txt")
    |> String.split("\n", trim: true)
    |> Enum.reduce(0, fn row, acc ->
      row_count = row
                  |> String.split("|")
                  |> Enum.map(&String.split/1)
                  |> Enum.at(1)
                  |> Enum.filter(&Enum.member?([2, 3, 4, 7], String.length(&1)))
                  |> Enum.count

      acc + row_count
    end)
    |> IO.inspect
  end

  def build_digit_to_signal_map(inputs) do
    # Order matters here, since some need to be discovered first
    [1, 4, 7, 8, 0, 6, 2, 3, 5, 9]
    |> Enum.reduce(%{}, fn number, acc ->
      signals =
        case number do
          1 -> inputs |> Enum.find(&(Enum.count(&1) === 2))
          4 -> inputs |> Enum.find(&(Enum.count(&1) === 4))
          7 -> inputs |> Enum.find(&(Enum.count(&1) === 3))
          8 -> inputs |> Enum.find(&(Enum.count(&1) === 7))

          0 ->
            # Six elements, and has 3 bits from the signal for 4 and all of 7
            inputs
            |> Enum.find(fn signal ->
              Enum.count(signal) === 6 &&
                Enum.count(acc[4] -- signal) === 1 &&
                Enum.count(acc[7] -- signal) === 0
            end)
          2 ->
            # Signal for 6, missing two, distinguished from 3 by missing one from signals for 1
            inputs
            |> Enum.find(fn signal ->
              Enum.count(signal) === 5 &&
                Enum.count(acc[6] -- signal) === 2 &&
                Enum.count(acc[1] -- signal) === 1
            end)
          3 ->
            # Five elements and contains all of the signal for 1
            inputs
            |> Enum.find(fn signal ->
              Enum.count(signal) === 5 && Enum.count(acc[1] -- signal) === 0
            end)
          5 ->
            # Signal for 6, missing 1
            inputs
            |> Enum.find(fn signal ->
              Enum.count(signal) === 5 && Enum.count(acc[6] -- signal) === 1
            end)
          6 ->
            # Six elements and contains only one from the signal for 1
            inputs
            |> Enum.find(fn signal ->
              Enum.count(signal) === 6 && Enum.count(acc[1] -- signal) === 1
            end)
          9 ->
           # Six elements and contains all of signals for 4 and 7
            inputs
            |> Enum.find(fn signal ->
              Enum.count(signal) === 6 &&
                Enum.count(acc[4] -- signal) === 0 &&
                Enum.count(acc[7] -- signal) === 0
            end)
        end

      Map.put(acc, number, signals)
    end)
  end

  def calculate_row_value(row) do
    [inputs, outputs] =
      row
      |> String.split("|")
      |> Enum.map(&String.split/1)

    decoder =
      inputs
      |> Enum.map(&(String.split(&1, "", trim: true)))
      |> build_digit_to_signal_map
      |> Map.new(fn {k, v} ->
        {
          v
          |> Enum.sort
          |> Enum.join(""),
          k
        }
      end)

    outputs
    |> Enum.reduce([], fn output, acc ->
      output_key =
        output
        |> String.split("", trim: true)
        |> Enum.sort
        |> Enum.join("")

      acc ++ [Map.get(decoder, output_key)]
    end)
    |> Enum.join("")
    |> String.to_integer
  end

  def star2() do
    File.read!("day08.txt")
    |> String.split("\n", trim: true)
    |> Enum.map(&calculate_row_value/1)
    |> Enum.sum
    |> IO.inspect
  end
end

Day08.star2()
