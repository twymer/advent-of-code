def load_file(filename = 'input.txt')
  File.open(filename).readlines.map do |line|
    line.chomp.split('')
  end
end

def walk_forest(slope, forest)
  count = 0
  i = 0
  j = 0

  until j >= forest.count
    count += 1 if forest[j][slope[0] * i % forest[j].count] == '#'
    j += slope[1]
    i += 1
  end

  count
end

forest = load_file('input.txt')

# Part 1

puts walk_forest([3, 1], forest)

# Part 2

slopes = [
  [1, 1],
  [3, 1],
  [5, 1],
  [7, 1],
  [1, 2]
]

tree_counts = slopes.map do |slope|
  walk_forest(slope, forest)
end
puts tree_counts.reduce(&:*)
