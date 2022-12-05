def load_file(filename = 'input.txt')
  stacks = {}
  instructions = []
  File.open(filename).readlines.each do |line|
    if line.include? '['
      crates = line.chars.each_slice(4).to_a.map { |x| x.join.delete("[] \n") }
      crates.each_with_index do |crate, i|
        unless crate.empty?
          if stacks.has_key?(i + 1)
            stacks[i + 1] << crate
          else
            stacks[i + 1] = [crate]
          end
        end
      end
    elsif
      line.include? 'move'
      instructions << line.chomp
    end
  end
  [stacks, instructions]
end

def run_instructions(stacks, instructions)
  instructions.each do |instruction|
    count, from, to = instruction.scan(/(\d+)/).flatten.map(&:to_i)
    stacks[to].unshift(*stacks[from].shift(count.to_i))
  end
  stacks
end

def get_answer(stacks)
  stacks.sort.map { |k, v| v.first }.join
end

stacks, instructions = load_file #('example.txt')
result_stacks = run_instructions(stacks, instructions)
puts get_answer(result_stacks)
