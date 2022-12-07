def load_file(filename = 'input.txt')
  File.open(filename).readlines
end

def determine_file_tree(commands)
  commands.reduce({tree: {'/' => {}}, current_path: []}) do |acc, command|
    case command
    when /\$ cd \.\./
      acc[:current_path].pop
    when /\$ cd (.+)/
      acc[:current_path] << $1
    when /\$ ls/
      # ignore unless we need to deal with bad input later
    when /dir (.+)/
      acc[:tree].dig(*acc[:current_path])[$1] = {}
    when /(\d+) (.+)/
      acc[:tree].dig(*acc[:current_path])[$2] = $1.to_i
    end

    acc
  end[:tree]
end

def calculate_directory_sizes(path, tree)
  result = tree.reduce({dir_sizes: {}, current_size: 0}) do |acc, (k, v)|
    if v.is_a? Integer
      acc[:current_size] += v
    else
      sub_dir_sizes, total_nested_size = calculate_directory_sizes(path + k, v)
      acc[:dir_sizes].merge!(sub_dir_sizes)
      acc[:current_size] += total_nested_size
    end

    acc
  end

  result[:dir_sizes][path] = result[:current_size]
  [result[:dir_sizes], result[:current_size]]
end

file = load_file
file_tree = determine_file_tree(file)
directory_sizes = calculate_directory_sizes('/', file_tree['/'])[0]

# Part 1
puts directory_sizes.select { |_, size| size <= 100000 }.map(&:last).sum

# Part 2
total_space = 70000000
required_space = 30000000
space_to_clear = required_space - (total_space - directory_sizes['/'])

puts directory_sizes.select { |_, size| size >= space_to_clear }.map(&:last).sort.first

