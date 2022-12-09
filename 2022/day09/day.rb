DIRS = {
  'L' => [-1, 0],
  'R' => [1, 0],
  'U' => [0, 1],
  'D' => [0, -1]
}

def load_file(filename = 'input.txt')
  File.open(filename).readlines.map do |line|
    line.chomp.split.yield_self { |dir, dist| [dir, dist.to_i] }
  end
end

def add_vectors(left, right)
  left.zip(right).map(&:sum)
end

def diff_vectors(left, right)
  left.zip(right).map { |l, r| l - r }
end

def follow_instruction(head, tail, dir, dist)
  return [head, tail, [tail]] if dist == 0

  head = add_vectors(head, DIRS[dir])
  diff = diff_vectors(head, tail)
  tail = add_vectors(tail, diff.map { |p| p <=> 0 }) if diff[0].abs > 1 || diff[1].abs > 1

  follow_instruction(head, tail, dir, dist - 1).yield_self do |h, t, v|
    [h, t, v << tail]
  end
end

instructions = load_file #('example.txt')
final_state = instructions.reduce([[0, 0], [0, 0], []]) do |acc, (dir, dist)|
  head, tail, visited = follow_instruction(acc[0], acc[1], dir, dist)
  [head, tail, acc[2] + visited]
end
puts final_state[2].uniq.count
