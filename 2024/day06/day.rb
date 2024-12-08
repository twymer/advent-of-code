require 'set'

def load_file(filename = 'input.txt')
  File.open(filename).readlines.map.with_index do |row, j|
    row.chomp.chars.map.with_index do |space, i|
      [[i, j], space]
    end.to_h
  end.inject(:merge)
end

def rotate(dir)
  case dir
  when [0, 1]
    [-1, 0]
  when [-1, 0]
    [0, -1]
  when [0, -1]
    [1, 0]
  when [1, 0]
    [0, 1]
  end
end

def walk(map, pos, dir, seen)
  new_pos = pos.zip(dir).map { |a, b| a + b }

  return false unless map.key?(pos)
  if seen.include?(new_pos + dir)
    return true
  end

  if map[new_pos] == '#'
    walk(map, pos, rotate(dir), seen)
  else
    walk(map, new_pos, dir, seen.add((new_pos + dir)))
  end
end

def find_guard(map)
  # NOTE guard is facing up in example and input provided, might need to adapt this later
  map.key('^')
end

map = load_file

guard_position = find_guard(map)

results = map.map do |pos, space|
  if space == '^' || space == '#'
    false
  else
    new_map = map.dup
    new_map[pos] = '#'
    walk(new_map, guard_position, [0, -1], Set[(guard_position + [0, -1])])
  end
end
puts results.flatten.count(true)
