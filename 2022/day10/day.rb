def load_file(filename = 'input.txt')
  File.open(filename).readlines.map { |line| line.chomp.split(' ') }
end

instructions = load_file

_, _, image = instructions.reduce([0, 1, Array.new(40 * 6, ' ')]) do |(cycle, x, img), (command, value)|
  if command == 'noop'
    img[cycle] = '#' if (cycle % 40 - x).abs <= 1
    [cycle + 1, x, img]
  else
    img[cycle] = '#' if (cycle % 40 - x).abs <= 1
    img[cycle + 1] = '#' if ((cycle + 1) % 40 - x).abs <= 1
    [cycle + 2, x + value.to_i, img]
  end
end

image.each_slice(40) { |row| puts row.join }
