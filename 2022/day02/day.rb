# A = Rock
# B = Paper
# C = Scissors
# X = Loss
# Y = Draw
# Z = Win

def load_file(filename = 'input.txt')
  File.open(filename).readlines.map(&:split)
end

def score_round(round)
  your_throw = case round
               when ['A', 'X']
                 'C'
               when ['A', 'Y']
                 'A'
               when ['A', 'Z']
                 'B'
               when ['B', 'X']
                 'A'
               when ['B', 'Y']
                 'B'
               when ['B', 'Z']
                 'C'
               when ['C', 'X']
                 'B'
               when ['C', 'Y']
                 'C'
               when ['C', 'Z']
                 'A'
               end

  (['A', 'B', 'C'].index(your_throw) + 1) + (3 * (['X', 'Y', 'Z'].index(round[1])))
end

all_rounds = load_file #('example.txt')
puts all_rounds.map { |round| score_round(round) }.sum
