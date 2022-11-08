def load_file(filename = 'input.txt')
  File.open(filename).readlines
end

def split_line(line)
  /(\d+)-(\d+) (\w): (.*)/.match(line).to_a[1..]
end

# Part 1
# def check_password(min, max, char, password)
#   (min.to_i..max.to_i).include? password.count(char)
# end

# Part 2
def check_password(left, right, char, password)
  (password[left.to_i - 1] == char) ^ (password[right.to_i - 1] == char)
end

def count_valid_passwords(lines)
  lines.reduce(0) do |count, line|
    count += check_password(*split_line(line)) ? 1 : 0
  end
end

lines = load_file('example.txt')
puts count_valid_passwords(lines)

lines = load_file('input.txt')
puts count_valid_passwords(lines)
