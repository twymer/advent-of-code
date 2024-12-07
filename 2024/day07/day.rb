def load_file(filename = 'input.txt')
  File.open(filename).readlines.map do |line|
    total, remainder = line.chomp.split(':') 
    [total.to_i, remainder.chomp.split(' ').map(&:to_i)]
  end
end

def concat(a, b)
  (a.to_s + b.to_s).to_i
end

def pop(numbers)
  [numbers[0], numbers[1..]]
end

def test(target_total, current_total, numbers)
  current_number, remaining_numbers = pop(numbers)

  # Initial state on first number
  if current_total.nil?
    return test(target_total, current_number, remaining_numbers)
  end

  if remaining_numbers.empty?
    target_total == current_total * current_number || 
      target_total == current_total + current_number ||
      target_total == concat(current_total, current_number)
  else
    test(target_total, current_total * current_number, remaining_numbers) ||
      test(target_total, current_total + current_number, remaining_numbers) ||
      test(target_total, concat(current_total, current_number), remaining_numbers)
  end
end

equations = load_file
result = equations.map do |equation|
  test(equation[0], nil, equation[1]) ? equation[0] : 0
end.sum
puts result
