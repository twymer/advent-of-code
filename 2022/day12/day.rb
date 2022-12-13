require 'set'

def load_file(filename = 'input.txt')
  File.open(filename).readlines.map.with_index do |row, j|
    row.chomp.chars.map.with_index do |height, i|
      [[i, j], height]
    end.to_h
  end.inject(:merge)
end

def height(value)
  letter = if value == 'E'
             'z'
           elsif value == 'S'
             'a'
           else
             value
           end

  ('a'..'z').to_a.find_index(letter)
end

def search_map(heightmap)
  destination = 'E'

  possible_starts = heightmap.select { |k, v| ['a', 'S'].include?(v) }.keys

  possible_starts.map do |start|
    queue = [[start, 0]]
    seen = Set[[0, 0]]

    until queue.empty? do
      current, depth = queue.shift

      if heightmap[current] == destination
        break depth
      end

      [[1, 0], [-1, 0], [0, 1], [0, -1]].each do |direction|
        new_location = current.zip(direction).map(&:sum)

        next unless heightmap.has_key?(new_location)
        next if seen.include?(new_location)
        next unless height(heightmap[new_location]) - height(heightmap[current]) <= 1

        queue << [new_location, depth + 1]
        seen << new_location
      end
    end
  end.compact.min
end

heightmap = load_file
puts search_map(heightmap)
