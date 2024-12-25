def load_file(filename = 'input.txt')
  File.open(filename).readlines.map { |line| line.chomp.split('').map(&:to_i) }
end

def find_trails(pos, topo_map, height)
  return 1 if height == 9

  directions = [[-1, 0], [1, 0], [0, -1], [0, 1]]

  directions.inject(0) do |score, dir|
    new_pos = [pos[0] + dir[0], pos[1] + dir[1]]

    next score if new_pos[0] < 0 || new_pos[1] < 0 || new_pos[1] >= topo_map.count || new_pos[0] >= topo_map[0].count

    score + if topo_map[new_pos[1]][new_pos[0]] == height + 1
      find_trails(new_pos, topo_map, height + 1)
    else
      0
    end
  end
end

def find_and_score_trailheads(topo_map)
  topo_map.each_with_index.inject(0) do |score, (row, j)|
    score + row.each_with_index.inject(0) do |row_score, (loc, i)|
      row_score + if loc == 0
        find_trails([i, j], topo_map, 0)
      else
        0
      end
    end
  end
end

topo_map = load_file
puts find_and_score_trailheads(topo_map)
