# NOTE This is the least proud I am of anything I've done in AoC so far...

defmodule Day18 do
  def find_next_number(pairs, :left, index) do
    pairs
    |> Enum.slice(0, index - 1)
    |> Enum.reverse
    |> find_next_number
  end

  def find_next_number(pairs, :right, index) do
    pairs
    |> Enum.slice((index + 1)..-1)
    |> find_next_number
  end

  def find_next_number(pairs) do
    pairs
    |> Enum.find(&(!Enum.member?(["[", "]", ","], elem(&1, 0))))
  end

  def replace_between(pairs, left_index, right_index, new_content) do
    if left_index && right_index do
      left_content = Enum.slice(pairs, 0..left_index)
      right_content = Enum.slice(pairs, right_index..-1)

      left_content ++ [new_content] ++ right_content
    else
      pairs
    end
  end

  # TODO shouldn't need this duplication
  def replace_between_with_pair(pairs, left_index, right_index, new_content) do
    if left_index && right_index do
      left_content = Enum.slice(pairs, 0..left_index)
      right_content = Enum.slice(pairs, right_index..-1)

      left_content ++ new_content ++ right_content
    else
      pairs
    end
  end

  def pprint(pairs) do
    pairs
    |> Enum.join("")
    |> IO.inspect

    pairs
  end

  def split(pairs) do
    split_index =
      pairs
      |> Enum.with_index
      |> find_split

    if split_index do
      split_number = String.to_integer(Enum.at(pairs, split_index))

      replacement =
        ["["] ++
          [Integer.to_string(div(split_number, 2))] ++
          [","] ++
          [Integer.to_string(ceil(split_number / 2))] ++
          ["]"]

      pairs
      |> replace_between_with_pair(
        split_index - 1,
        split_index + 1,
        replacement
      )
    else
      pairs
    end
  end

  def explode(pairs) do
    explosion_index =
      pairs
      |> Enum.with_index
      |> find_explode(0)

    if explosion_index do
      left_exploder = Enum.at(pairs, explosion_index) |> String.to_integer
      right_exploder = Enum.at(pairs, explosion_index + 2) |> String.to_integer

      pairs =
        pairs
        |> replace_between(
          explosion_index - 2,
          explosion_index + 4,
          "0"
        )

      explosion_index = explosion_index - 1

      next_left =
        pairs
        |> Enum.with_index
        |> find_next_number(:left, explosion_index)

      next_right =
        pairs
        |> Enum.with_index
        |> find_next_number(:right, explosion_index)

      pairs = if next_left do
        pairs
        |> replace_between(
          elem(next_left, 1) - 1,
          elem(next_left, 1) + 1,
          Integer.to_string(String.to_integer(elem(next_left, 0)) + left_exploder)
        )
      else
        pairs
      end

      if next_right do
        pairs
        |> replace_between(
          elem(next_right, 1) - 1,
          elem(next_right, 1) + 1,
          Integer.to_string(String.to_integer(elem(next_right, 0)) + right_exploder)
        )
      else
        pairs
      end
    else
      pairs
    end
  end

  def find_explode([], _), do: nil
  def find_explode(pairs, depth) do
    [{current, index} | rest] = pairs

    case current do
      "[" ->
        find_explode(rest, depth + 1)
      "]" ->
        find_explode(rest, depth - 1)
      "," ->
        find_explode(rest, depth)
      _ ->
        # "Exploding pairs will always consist of two regular numbers."
        if depth > 4 do
          index
        else
          find_explode(rest, depth)
        end
    end
  end

  def to_int(token) do
    # TODO this doesn't feel very elixir-y
    if Integer.parse(token) != :error do
      elem(Integer.parse(token), 0)
    else
      nil
    end
  end

  def find_split([]), do: nil
  def find_split(pairs) do
    [{current, index} | rest] = pairs

    current_converted = to_int(current)

    cond do
      current_converted && current_converted > 9 ->
        index
      true ->
        find_split(rest)
    end
  end

  def add(left, right) do
    ["["] ++ left ++ [","] ++ right ++ ["]"]
  end

  def reduce(pairs) do
    exploded_pairs =
      pairs
      |> explode

    if exploded_pairs === pairs do
      split_pairs =
        pairs
        |> split

      if split_pairs === pairs do
        pairs
      else
        reduce(split_pairs)
      end
    else
      reduce(exploded_pairs)
    end
  end

  def score(pairs) do
    pairs
    |> Enum.join("")
    |> score_string
    |> String.to_integer
  end

  def score_string(pairs_string) do
    regex = ~r/\[(\d+),(\d+)\]/

    updated =
      Regex.replace(regex, pairs_string, fn _, left, right ->
        String.to_integer(left) * 3 + String.to_integer(right) * 2
        |> Integer.to_string
      end)

    if updated == pairs_string do
      pairs_string
    else
      score_string(updated)
    end
  end

  def star1 do
    lines =
      File.read!("day18.txt")
      |> String.split("\n", trim: true)
      |> Enum.map(&(String.split(&1, "", trim: true)))

    start_state =
      lines
      |> Enum.at(0)

    lines
    |> Enum.slice(1..-1)
    |> Enum.reduce(start_state, fn line, acc ->
      acc
      |> add(line)
      |> reduce
    end)
    |> score
  end

  def star2 do
    lines =
      File.read!("day18.txt")
      |> String.split("\n", trim: true)
      |> Enum.map(&(String.split(&1, "", trim: true)))

    Enum.reduce(0..Enum.count(lines) - 1, 0, fn i, acc ->
      Enum.reduce(0..Enum.count(lines) - 1, acc, fn j, acc ->
        if i == j do
          acc
        else
          one = Enum.at(lines, i)
          two = Enum.at(lines, j)

          one_plus_two =
            one
            |> add(two)
            |> reduce
            |> score

          two_plus_one =
            two
            |> add(one)
            |> reduce
            |> score

          Enum.max([one_plus_two, two_plus_one, acc])
        end
      end)
    end)
  end
end

Day18.star2()
|> IO.inspect
