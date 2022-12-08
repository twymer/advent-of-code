def load_file(filename = 'input.txt')
  File.open(filename).readlines.map do |line|
    line.chomp.chars.map(&:to_i)
  end
end

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

def count_visible_trees(forest)
  forest.each_with_index.reduce(0) do |count, (row, j)|
    count + row.each_with_index.reduce(0) do |inner_count, (tree, i)|
      inner_count + (is_visible?(forest, [i, j]) ? 1 : 0)
    end
  end
end

forest = load_file('example.txt')
puts count_visible_trees(forest)
