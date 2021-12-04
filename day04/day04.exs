defmodule Day04 do
  def check_horizontals(board, hits) do
    board
    |> Enum.map(fn row ->
      Enum.all?(row, fn square -> Enum.member?(hits, square) end)
    end)
    |> Enum.any?
  end

  def check_verticals(board, hits) do
    # To check verticals all we actually do is transpose the board
    # and treat it like checking horizontals
    board
    |> Enum.zip
    |> Enum.map(&(Tuple.to_list(&1)))
    |> check_horizontals(hits)
  end

  def score_board(board, hits) do
    board
    |> List.flatten
    |> Enum.filter(fn n -> !Enum.member?(hits, n) end)
    |> Enum.map(&(String.to_integer(&1)))
    |> Enum.sum
  end

  def parse_file() do
    [unparsed_hits | unparsed_boards] =
      File.read!("day04.txt")
      |> String.split("\n", trim: true)

    hits = String.split(unparsed_hits, ",")

    boards =
      unparsed_boards
      |> Enum.map(&(String.split(&1))) 
      |> Enum.chunk_every(5)

    [hits, boards]
  end

  def star1() do
    [hits, boards] = parse_file()

    result = Enum.reduce_while(hits, %{current_hits: []}, fn n, acc ->
      current_hits = acc.current_hits ++ [n]

      winner = boards
      |> Enum.find(fn board ->
        check_horizontals(board, current_hits) || check_verticals(board, current_hits)
      end)

      if winner do
        {:halt, %{current_hits: current_hits, board: winner, final_number: n}}
      else
        {:cont, %{current_hits: current_hits}}
      end
    end)
    |> IO.inspect

    score = score_board(result.board, result.current_hits)
    |> IO.inspect

    score * String.to_integer(result.final_number)
    |> IO.inspect
  end

  def star2() do
    [hits, boards] = parse_file()

    result = Enum.reduce_while(hits, %{current_hits: []}, fn n, acc ->
      current_hits = acc.current_hits ++ [n]

      winners = boards
      |> Enum.filter(fn board ->
        check_horizontals(board, current_hits) || check_verticals(board, current_hits)
      end)

      if Enum.count(winners) === Enum.count(boards) do
        new_winner = winners -- acc.previous_winners
        {:halt, %{current_hits: current_hits, last_board: new_winner, final_number: n}}
      else
        {:cont, %{current_hits: current_hits, previous_winners: winners}}
      end
    end)
    |> IO.inspect

    score = score_board(result.last_board, result.current_hits)
    |> IO.inspect

    score * String.to_integer(result.final_number)
    |> IO.inspect
  end
end

# Day04.star1()
Day04.star2()
