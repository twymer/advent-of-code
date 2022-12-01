def run(filename = 'input.txt')
  File.read(filename).split("\n\n").map do |foods|
    foods.split("\n").map(&:to_i).sum
  end.max(3).sum
end

puts run
