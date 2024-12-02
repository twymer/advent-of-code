def run(filename = 'input.txt')
  left, right = [[], []]
  File.read(filename).split("\n").map do |line|
    l, r = line.split
    left << l.to_i
    right << r.to_i
  end

  left.sort.zip(right.sort).inject(0) do |sum, pair|
    l, r = pair
    sum + (l - r).abs
  end
end

puts run
