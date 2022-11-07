def load_file(filename = 'input.txt')
  File.open(filename).readlines.map(&:to_i)
end

def run_part_1(numbers)
  numbers.each_with_index do |left, i|
    numbers[i+1..].each_with_index do |right, j|
      return left * right if left + right == 2020
    end
  end
end

def run_part_2(numbers)
  numbers.each_with_index do |left, i|
    numbers[i+1..].each_with_index do |right, j|
      numbers[i+j+1..].each_with_index do |middle, k|
        return left * right * middle if left + right + middle == 2020
      end
    end
  end
end

numbers = load_file

puts run_part_1(numbers)
puts run_part_2(numbers)
