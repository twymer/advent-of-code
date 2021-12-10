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

  def closing_bracket?(b) do
    Enum.member?([")", "]", "}", ">"], b)
  end

  def score_bracket(b) do
    case b do
      ")" -> 3
      "]" -> 57
      "}" -> 1197
      ">" -> 25137
    end
  end

  def check_corrupted({:corrupted, bracket}) do
    bracket
  end

  def check_corrupted(_) do
    nil
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
          {:halt, {:corrupted, bracket}}
      end
    end)
    |> check_corrupted
  end

  def star1 do
    load_file()
    |> Enum.map(&(parse/1))
    |> Enum.filter(&(&1))
    |> Enum.frequencies
    |> Enum.reduce(0, fn {bracket, count}, acc ->
      acc + score_bracket(bracket) * count
    end)
    |> IO.inspect
  end
end

Day10.star1()
