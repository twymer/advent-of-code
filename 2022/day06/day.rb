MARKER_LENGTH = 14

def load_file(filename = 'input.txt')
  File.open(filename).read.chomp
end

def find_marker(signal)
  signal.chars.each_cons(MARKER_LENGTH).with_index.find do |slice, _|
    slice.uniq.count == MARKER_LENGTH
  end
end

signal = load_file
puts find_marker(signal)[1] + MARKER_LENGTH
