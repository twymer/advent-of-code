def load_file(filename = 'input.txt')
  File.open(filename).readlines.map do |line|
    line.chomp.chars.map(&:to_i)
  end
end

# Part 1
def is_visible?(forest, position)
  height = forest.count
  width = forest[0].count
  tree = forest[position[1]][position[0]]

  (
    (0...position[1]).all? { |j| forest[j][position[0]] < tree} || # top
    (position[1]+1...height).all? { |j| forest[j][position[0]] < tree } || # bottom
    (0...position[0]).all? { |i| forest[position[1]][i] < tree } || # left
    (position[0]+1...width).all? { |i| forest[position[1]][i] < tree } # right
  )
end

# Part 1
def count_visible_from_edge(forest)
  forest.each_with_index.reduce(0) do |count, (row, j)|
    count + row.each_with_index.reduce(0) do |inner_count, (tree, i)|
      inner_count + (is_visible?(forest, [i, j]) ? 1 : 0)
    end
  end
end

# Part 2
def count_visible(forest, position)
  height = forest.count
  width = forest[0].count
  tree = forest[position[1]][position[0]]

  [
    # top
    (position[1] - 1).downto(0).reduce(0) { |count, j| forest[j][position[0]] >= tree ? (break count + 1) : count + 1 },
    # bottom
    (position[1] + 1).upto(height - 1).reduce(0) { |count, j| forest[j][position[0]] >= tree ? (break count + 1) : count + 1 },
    # left
    (position[0] - 1).downto(0).reduce(0) { |count, i| forest[position[1]][i] >= tree ? (break count + 1) : count + 1 },
    # right
    (position[0] + 1).upto(height - 1).reduce(0) { |count, i| forest[position[1]][i] >= tree ? (break count + 1) : count + 1 }
  ].inject(:*)
end

# Part 2
def calculate_scenic_scores(forest)
  forest.count.times.map do |j|
    forest[0].count.times.map do |i|
      count_visible(forest, [i, j])
    end
  end
end

forest = load_file
puts count_visible_from_edge(forest)
puts calculate_scenic_scores(forest).flatten.max
