def load_file(filename = 'input.txt')
  File.open(filename).readlines.map do |line|
    line.chomp.split('')
  end
end

def walk_forest(slope, forest)
  count = 0

  forest.each_with_index do |row, i|
    count += 1 if row[slope * i % row.count] == '#'
  end

  count
end

forest = load_file('input.txt')

puts walk_forest(3, forest)
