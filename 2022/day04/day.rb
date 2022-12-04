def load_file(filename = 'input.txt')
  File.open(filename).readlines.map do |line|
    line.chomp.split(',').map do |assignments|
      Range.new(*assignments.split('-').map(&:to_i))
    end
  end
end

def count_overlaps(pair_assignments)
  pair_assignments.count do |elf_one, elf_two|
    elf_one.cover?(elf_two.first) || elf_two.cover?(elf_one.first)
  end
end

pair_assignments = load_file
puts count_overlaps(pair_assignments)
