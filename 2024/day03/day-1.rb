def load_file(filename = 'input.txt')
  File.read(filename)
end

def parse_muls(input)
  input.scan(/mul\((\d+,\d+)\)/).map(&:first).map { |mul| mul.split(',').map(&:to_i) }
end

def multiply(values)
  values.inject(0) { |sum, pair| sum + pair[0] * pair[1] }
end

# puts multiply([[2, 4], [5, 5], [11, 8], [8, 5]])
puts multiply(parse_muls(load_file))

# print memory
