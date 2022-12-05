def load_file(filename = 'input.txt')
  file = File.open(filename).read.split("\n\n")

  stacks = file[0].split("\n")[0...-1].map do |line|
    line.chomp.chars
  end.transpose.each_slice(4).map do |slice|
    slice[1].reject { |crate| crate == " " }
  end

  instructions = file[1].split("\n")

  [stacks, instructions]
end

def run_instructions(stacks, instructions)
  instructions.reduce(stacks) do |acc_stacks, instruction|
    count, from, to = instruction.scan(/(\d+)/).flatten.map(&:to_i)
    acc_stacks[to - 1].unshift(*acc_stacks[from - 1].shift(count))
    acc_stacks
  end
end

stacks, instructions = load_file
result_stacks = run_instructions(stacks, instructions)
puts result_stacks.map(&:first).join
