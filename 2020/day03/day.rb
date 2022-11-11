def load_file(filename = 'input.txt')
  File.open(filename).readlines.map do |line|
    line.chomp.split('')
  end
end

def walk_forest(slope, forest)
  forest_width = forest[0].count
  vertical_steps = (0...forest.count).step(slope[1])

  vertical_steps.each_with_index.map do |j, i|
    forest[j][slope[0] * i % forest_width] == '#' ? 1 : 0
  end.sum
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

puts slopes.map { |slope| walk_forest(slope, forest) }.reduce(&:*)
