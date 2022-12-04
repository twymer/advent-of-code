def load_file(filename = 'input.txt')
  File.open(filename).readlines.map do |line|
    line.chomp.split(',').map do |assignments|
      assignments.split('-').map(&:to_i)
    end
  end
end

def count_overlaps(pair_assignments)
  pair_assignments.count do |elf_one, elf_two|
    (
      (
        elf_one.first.between?(elf_two.first, elf_two.last) ||
        elf_one.last.between?(elf_two.first, elf_two.last)
      ) ||
      (
        elf_two.first.between?(elf_one.first, elf_one.last) ||
        elf_two.last.between?(elf_one.first, elf_one.last)
      )
    )
  end
end

pair_assignments = load_file
puts count_overlaps(pair_assignments)
