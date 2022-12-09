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

def follow_instruction(head, knots, dir, dist)
  return [head, knots, [knots.last]] if dist == 0

  head = add_vectors(head, DIRS[dir])

  moved_knots = knots.each_with_index.reduce(knots.dup) do |acc_knots, (knot, i)|
    diff = i == 0 ? diff_vectors(head, knot) : diff_vectors(acc_knots[i - 1], knot)
    acc_knots[i] = add_vectors(knot, diff.map { |p| p <=> 0 }) if diff[0].abs > 1 || diff[1].abs > 1
    acc_knots
  end

  follow_instruction(head, moved_knots, dir, dist - 1).yield_self do |h, k, v|
    [h, k, v << moved_knots.last]
  end
end

instructions = load_file
final_state = instructions.reduce([[0, 0], Array.new(9) { [0, 0] }, []]) do |acc, (dir, dist)|
  head, knots, visited = follow_instruction(acc[0], acc[1], dir, dist)
  [head, knots, acc[2] + visited]
end
puts final_state[2].uniq.count
