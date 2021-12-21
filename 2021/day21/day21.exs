defmodule Day21 do
  def dirac_outcomes do
    %{3 => 1, 4 => 3, 5 => 6, 6 => 7, 7 => 6, 8 => 3, 9 => 1}
  end

  def move_player(previous, distance) do
    rem(previous + distance - 1, 10) + 1
  end

  def check_and_roll(scores, positions) do
    winning_score = 21

    Enum.reduce(Map.keys(dirac_outcomes()), %{1 => 0, 2 => 0}, fn player1_roll, acc ->
      player1_position = move_player(
        Map.get(positions, 1),
        player1_roll
      )
      player1_score = Map.get(scores, 1) + player1_position
      player1_frequency = Map.get(dirac_outcomes(), player1_roll)

      if player1_score >= winning_score do
        Map.update!(acc, 1, &(&1 + player1_frequency))
      else
        Enum.reduce(Map.keys(dirac_outcomes()), acc, fn player2_roll, acc ->
          player2_position = move_player(
            Map.get(positions, 2),
            player2_roll
          )
          player2_score = Map.get(scores, 2) + player2_position
          player2_frequency = Map.get(dirac_outcomes(), player2_roll)

          if player2_score >= winning_score do
            Map.update!(acc, 2, &(&1 + player1_frequency * player2_frequency))
          else
            wins = check_and_roll(
              %{1 => player1_score, 2 => player2_score},
              %{1 => player1_position, 2 => player2_position}
            )

            acc
            |> Map.update!(1, fn original ->
              original + Map.get(wins, 1) * player1_frequency * player2_frequency
            end)
            |> Map.update!(2, fn original ->
              original + Map.get(wins, 2) * player1_frequency * player2_frequency
            end)
          end
        end)
      end
    end)
  end

  def star2 do
    positions = %{1 => 5, 2 => 9}
    scores = %{1 => 0, 2 => 0}

    check_and_roll(scores, positions)
    |> IO.inspect
    |> Map.values
    |> Enum.max
    |> IO.inspect
  end
end
Day21.star2()
