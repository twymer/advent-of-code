defmodule Day10 do
  def load_file do
    File.read!("day10.txt")
    |> String.split("\n", trim: true)
  end

  def brackets_match?(b1, b2) do
    b1 === "(" and b2 === ")" or
    b1 === "{" and b2 === "}" or
    b1 === "<" and b2 === ">" or
    b1 === "[" and b2 === "]"
  end

  def opening_bracket?(b) do
    Enum.member?(["(", "[", "{", "<"], b)
  end

  def score_bracket(b) do
    case b do
      "(" -> 1
      "[" -> 2
      "{" -> 3
      "<" -> 4
    end
  end

  def parse(line) do
    String.split(line, "", trim: true)
    |> Enum.reduce_while([], fn bracket, open_brackets ->
      cond do
        opening_bracket?(bracket) ->
          {:cont, open_brackets ++ [bracket]}
        brackets_match?(Enum.at(open_brackets, -1), bracket) ->
          {:cont, Enum.drop(open_brackets, -1)}
        true ->
          {:halt, nil}
      end
    end)
  end

  def score_brackets(brackets) do
    brackets
    |> Enum.reverse
    |> Enum.map(&score_bracket/1)
    |> Enum.reduce(0, fn bracket_score, acc ->
      acc * 5 + bracket_score
    end)
  end

  def star2 do
    score_list = load_file()
    |> Enum.map(fn line ->
      parse(line)
    end)
    |> Enum.filter(&(&1))
    |> Enum.map(&score_brackets/1)
    |> Enum.sort

    Enum.at(score_list, div(Enum.count(score_list), 2))
    |> IO.inspect
  end
end

Day10.star2()
