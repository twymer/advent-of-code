def load_file(filename = 'input.txt')
  File.open(filename).readlines.map { |line| line.chomp.chars }
end

def star_1(ruck_sacks)
  ruck_sacks.map { |contents|
    compartment_one, compartment_two = contents.each_slice(contents.size / 2).to_a
    compartment_one & compartment_two
  }.flatten.reduce(0) { |sum, item|
    sum + [*'a'..'z', *'A'..'Z'].index(item) + 1
  }
end

def star_2(ruck_sacks)
  ruck_sacks.each_slice(3).map do |elf_one, elf_two, elf_three|
    elf_one & elf_two & elf_three
  end.flatten.reduce(0) { |sum, item|
    sum + [*'a'..'z', *'A'..'Z'].index(item) + 1
  }
end

ruck_sacks = load_file

puts star_1(ruck_sacks)
puts star_2(ruck_sacks)
