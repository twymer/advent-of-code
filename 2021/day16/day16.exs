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
    |> IO.inspect
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

  def process_transmission_chunk([]), do: nil
  def process_transmission_chunk(transmission) do
    transmission
    |> start_next_packet
    |> process_transmission_chunk
  end

  def process_transmission_count([], 0), do: nil
  def process_transmission_count(transmission, count) do
    transmission
    |> start_next_packet
    |> process_transmission_count(count - 1)
  end

  def start_next_packet(transmission) do
    IO.puts "starting"
    transmission
    |> Enum.join("")
    |> IO.puts

    if Enum.all?(transmission, &(&1 === "0")) do
      version =
        transmission
        |> Enum.slice(0, 3)
        |> to_int

      type =
        transmission
        |> Enum.slice(3, 3)
        |> to_int

      # require IEx; IEx.pry

      transmission
      |> Enum.slice(6..-1)
      |> then(&(process_packet(version, type, &1)))
    else
      IO.puts "FIN"
    end
  end

  ### Version *, type 4
  ### Literal value
  def process_packet(_, 4, transmission) do
    IO.puts "literal"

    literal = read_literal(transmission)
    literal
    |> Enum.join("")
    |> IO.inspect

    length = Enum.count(literal) + div(Enum.count(literal), 4)

    Enum.slice(transmission, length..-1)

    # Padded to multiple of 4, clear dead space
    # TODO shouldn't need to add length here
    # {_, remaining_transmission} = Enum.split(transmission, length + padding(length, 4))
    # remaining_transmission
  end

  ### Version *, type *
  ### Operator value types
  def process_packet(_, _, transmission) do
    IO.puts "Operator"
    transmission
    |> Enum.join("")
    |> IO.inspect

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

      current_chunk
      |> Enum.slice(16..length)
      |> process_transmission_chunk

      remaining
    else
      count = Enum.slice(transmission, 1, 11)
      transmission
      |> Enum.slice(12..-1)
      |> process_transmission_count(count)
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