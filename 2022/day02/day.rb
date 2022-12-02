def load_file(filename = 'input.txt')
  File.open(filename).readlines.map(&:split)
end

def score_round(round)
  choices = ['A', 'B', 'C']
  results = ['X', 'Y', 'Z']

  opponent_index = choices.index(round[0])
  result = results.index(round[1])

  chosen_move_index = (opponent_index + result - 1) % 3 + 1
  result_scoring = results.index(round[1]) * 3

  chosen_move_index + result_scoring
end

puts load_file.reduce(0) { |sum, round| sum + score_round(round) }
