def load_file(filename = 'input.txt')
  File.read(filename)
end

def parse_commands(input)
  input.scan(/((mul\(\d+,\d+\))|don't\(\)|do\(\))/).map(&:first)
end

commands = parse_commands(load_file)

results = commands.inject({ val: 0, on: true }) do |memo, command|
  if command === 'do()'
    { val: memo[:val], on: true }
  elsif command === "don't()"
    { val: memo[:val], on: false }
  else
    puts command
    a, b = /(mul\((\d+),(\d+)\))/.match(command)[2..].map(&:to_i)
    puts "#{a},#{b}"

    if memo[:on]
      { val: memo[:val] + a * b, on: true }
    else
      { val: memo[:val], on: false }
    end
  end
end

puts results[:val]
