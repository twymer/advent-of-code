def load_file(filename = 'input.txt')
  File.open(filename).readlines.map { |line| line.chomp.split(' ').map(&:to_i) }
end

def check_level(level, rechecking = false)
  max_change = 3

  # TODO there has to be a better way to deal with needing to delete
  # the first number because of bad directionality on the first pair
  # increasing = level[0] < level[1]
  directions = level.each_cons(2).map do |l, r|
    l < r
  end
  increasing = directions.max_by { |i| directions.count(i) }

  level.each_cons(2).each_with_index do |pair, index|
    l, r = pair
    unless (increasing && r > l && r <= l + max_change) || (!increasing && r < l && r >= l - max_change)
      return false if rechecking

      without_left = level.dup.tap { |arr| arr.delete_at(index) }
      without_right = level.dup.tap { |arr| arr.delete_at(index + 1) }
      return check_level(without_left, true) || check_level(without_right, true)
    end
  end

  true
end

levels = load_file

puts levels.map { |level| check_level(level) }.count(true)
