def load_file(filename = 'input.txt')
  File.open(filename).readlines.map { |line| line.chomp.split('') }
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

  return seen.uniq.count if (
    new_pos[0] < 0 ||
    new_pos[1] < 0 ||
    new_pos[0] >= map[0].count ||
    new_pos[1] >= map.count
  )

  if map[new_pos[1]][new_pos[0]] == '#'
    walk(map, pos, rotate(dir), seen)
  else
    walk(map, new_pos, dir, seen + [new_pos])
  end
end

def find_guard(map)
  # NOTE guard is facing up in example and input provided, might need to adapt this later
  idx = map.flatten.find_index('^')
  [idx % map.count, idx / map.count]
end

map = load_file

guard_position = find_guard(map)

puts walk(map, guard_position, [0, -1], [guard_position])
