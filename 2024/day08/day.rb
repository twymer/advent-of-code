require 'matrix'

def load_file(filename = 'input.txt')
  File.open(filename).readlines.map { |line| line.chomp.split('') }
end

def print_arr(arr)
  arr.each { |row| puts row.join }
end

def find_antennas(map)
  map.each_with_index.inject({}) do |antennas, (row, j) |
    row.each_with_index.inject(antennas) do |inner_antennas, (loc, i) |
      if loc != '.'
        if inner_antennas.key?(loc)
          inner_antennas[loc] << [i, j]
        else
          inner_antennas[loc] = [[i, j]]
        end
      end
      inner_antennas
    end
  end
end

def is_linear?(p, a, b)
  p_to_a = [p[0] - a[0], p[1] - a[1]]
  p_to_b = [p[0] - b[0], p[1] - b[1]]
  scalar_cross_product = p_to_a[0] * p_to_b[1] - p_to_a[1] * p_to_b[0]

  scalar_cross_product == 0
end

def is_antinode?(antennas, point)
  antennas.any? do |antenna, locs|
    locs.combination(2).any? do |a, b|
      # NOTE commented out code is the difference between star 1 and star 2 solution
      # dist_to_a = (point[0] - a[0]).abs + (point[1] - a[1]).abs
      # dist_to_b = (point[0] - b[0]).abs + (point[1] - b[1]).abs
      is_linear?(point, a, b) # && (dist_to_a == 2 * dist_to_b || dist_to_b == 2 * dist_to_a)
    end
  end
end

antenna_map = load_file
antennas = find_antennas(antenna_map)
results = (0...antenna_map.count).each_with_index.map do |_, j|
  (0...antenna_map[0].count).each_with_index.map do |_, i|
    is_antinode?(antennas, [i, j]) ? '#' : '.'
  end
end

# NOTE hacky way to accumulate but left the setup like this to help debugging
# print_arr(results)
puts results.flatten.count('#')
