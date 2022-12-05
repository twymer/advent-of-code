def load_file(filename = 'input.txt')
  stacks = Hash.new { |h, k| h[k] = [] }

  file = File.open(filename).read.split("\n\n")

  file[0][0...-1].split("\n").map do |line|
    crates = line.chars.each_slice(4).map { |x| x.join.delete("[] \n") }
    crates.each_with_index do |crate, i|
      next if crate.empty?
      stacks[i + 1] << crate
    end
  end

  instructions = file[1].split("\n")

  [stacks, instructions]
end

def run_instructions(stacks, instructions)
  instructions.each do |instruction|
    count, from, to = instruction.scan(/(\d+)/).flatten.map(&:to_i)
    stacks[to].unshift(*stacks[from].shift(count))
  end
  stacks
end

def get_answer(stacks)
  stacks.sort.map { |k, v| v.first }.join
end

stacks, instructions = load_file
result_stacks = run_instructions(stacks, instructions)
puts get_answer(result_stacks)
