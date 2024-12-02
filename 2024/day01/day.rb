def run(filename = 'input.txt')
  left, right = [[], []]
  File.read(filename).split("\n").map do |line|
    l, r = line.split
    left << l.to_i
    right << r.to_i
  end

  left.inject(0) do |sum, n|
    sum + n * right.count(n)
  end
end

puts run
