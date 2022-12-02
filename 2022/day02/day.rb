def load_file(filename = 'input.txt')
  File.open(filename).readlines.map(&:split)
end

def score_round(round)
  # A = Rock
  # B = Paper
  # C = Scissors
  # X = Rock
  # Y = Paper
  # Z = Scissors
  result = case round
           when ['A', 'X']
             1
           when ['A', 'Y']
             2
           when ['A', 'Z']
             0
           when ['B', 'X']
             0
           when ['B', 'Y']
             1
           when ['B', 'Z']
             2
           when ['C', 'X']
             2
           when ['C', 'Y']
             0
           when ['C', 'Z']
             1
           end

  result * 3 + ['X', 'Y', 'Z'].index(round[1]) + 1
end

all_rounds = load_file #('example.txt')
puts all_rounds.map { |round| score_round(round) }.sum
