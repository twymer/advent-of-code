def load_file(filename = 'input.txt')
  File.open(filename).readlines.map(&:to_i)
end

def find_sum_tuple(numbers, size, goal)
  numbers.combination(size).find { |tuple| tuple.sum == goal }.reduce(&:*)
end

numbers = load_file

puts find_sum_tuple(numbers, 2, 2020)
puts find_sum_tuple(numbers, 3, 2020)
