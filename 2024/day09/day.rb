require 'matrix'

def load_file(filename = 'input.txt')
  File.open(filename).read.chomp.chars.map(&:to_i)
end

def process_map(disk_map)
  disk_map.each_with_index.inject([]) do |state, (val, i)|
    if i % 2 == 0
      state + ([(i + 1) / 2] * val)
    else
      state + ([nil] * val)
    end
  end
end

def defrag(disk_state)
  replacements = disk_state.compact.reverse
  disk_state.each_with_index.inject({state: [], replaced: 0}) do |memo, (bit, i)|
    if bit
      {
        state: memo[:state] << bit,
        replaced: memo[:replaced]
      }
    else
      {
        state: memo[:state] << replacements[memo[:replaced]],
        replaced: memo[:replaced] + 1
      }
    end
  end[:state][0...(disk_state.count - disk_state.count(nil))]

  # return disk_state unless disk_state.include? nil
  #
  # bit = disk_state[-1]
  # remaining_state = disk_state[0...-1]
  #
  # first_blank = remaining_state.find_index(nil)
  # remaining_state[first_blank] = bit
  #
  # defrag(remaining_state)
end

def score(disk_state)
  disk_state.each_with_index.inject(0) do |score, (bit, i)|
    score + (bit * i)
  end
end

disk_map = load_file
disk_state = process_map(disk_map)

defragged = defrag(disk_state)
puts defragged.join
puts score(defragged)
