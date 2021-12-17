defmodule Day16 do
  def load_file do
    File.read!("day16.txt")
    |> String.trim
    |> String.split("", trim: true)
    |> Enum.map(fn hex_digit ->
      hex_digit
      |> Integer.parse(16)
      |> elem(0)
      |> Integer.to_string(2)
      |> String.pad_leading(4, "0")
    end)
    |> Enum.join("")
    |> String.split("", trim: true)
  end

  def to_int(bits) do
    bits
    |> Enum.join("")
    |> String.to_integer(2)
  end

  def convert_hex([]), do: ""
  def convert_hex(<<head, rest::binary>>) do
    head
    |> Integer.to_string(2)
    |> then(&(&1 <> convert_hex(rest)))
  end

  def process_transmission_chunk([]), do: %{remaining_transmission: [], version_total: 0}
  def process_transmission_chunk(transmission) do
    next_result = transmission
    |> start_next_packet

    remaining_result =
      next_result.remaining_transmission
      |> process_transmission_chunk

    %{
      version_total: next_result.version_total + remaining_result.version_total,
      remaining_transmission: remaining_result.remaining_transmission
    }
  end

  def process_transmission_count(remaining, 0) do
    %{remaining_transmission: remaining, version_total: 0}
  end
  def process_transmission_count(transmission, count) do
    next_result = transmission
    |> start_next_packet

    remaining_result =
      next_result.remaining_transmission
      |> process_transmission_count(count - 1)

    %{
      version_total: next_result.version_total + remaining_result.version_total,
      remaining_transmission: remaining_result.remaining_transmission
    }
  end

  def start_next_packet(transmission) do
    unless Enum.all?(transmission, &(&1 === "0")) do
      version =
        transmission
        |> Enum.slice(0, 3)
        |> to_int

      type =
        transmission
        |> Enum.slice(3, 3)
        |> to_int

      transmission
      |> Enum.slice(6..-1)
      |> then(&(process_packet(version, type, &1)))
    else
      %{
        version_total: 0,
        remaining_transmission: []
      }
    end
  end

  ### Version *, type 4
  ### Literal value
  def process_packet(version, 4, transmission) do
    # IO.puts "Literal"
    # transmission
    # |> Enum.join("")
    # |> IO.inspect

    literal = read_literal(transmission)

    length = Enum.count(literal) + div(Enum.count(literal), 4)

    %{
      version_total: version,
      remaining_transmission: Enum.slice(transmission, length..-1)
    }
  end

  ### Version *, type *
  ### Operator value types
  def process_packet(version, _, transmission) do
    # IO.puts "Operator"
    # transmission
    # |> Enum.join("")
    # |> IO.inspect

    length_type = List.first(transmission)

    if length_type === "0" do
      length =
        transmission
        |> Enum.slice(1, 15)
        |> to_int

      {current_chunk, remaining} =
        transmission
        |> Enum.slice(16..-1)
        |> Enum.split(length)

      nested_results =
        current_chunk
        |> process_transmission_chunk

      %{
        version_total: version + nested_results.version_total,
        remaining_transmission: remaining
      }
    else
      count =
        transmission
        |> Enum.slice(1, 11)
        |> to_int

      nested_results =
        transmission
        |> Enum.slice(12..-1)
        |> process_transmission_count(count)

      %{
        version_total: version + nested_results.version_total,
        remaining_transmission: nested_results.remaining_transmission
      }
    end
  end

  def padding(actual, interval) do
    (interval + (actual - rem(interval, actual))) - actual
  end

  def read_literal(transmission) do
    {value_data, remaining_transmission} = Enum.split(transmission, 5)
    [continue_bit | raw_value] = value_data

    if continue_bit === "1" do
      raw_value ++ read_literal(remaining_transmission)
    else
      raw_value
    end
  end

  def star1 do
    load_file()
    |> start_next_packet
    |> IO.inspect
  end
end

Day16.star1()
