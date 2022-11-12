require 'set'

def load_file(filename = 'input.txt')
  passports = []
  current = {}

  File.open(filename).readlines.each do |line|
    if line == "\n"
      passports << current
      current = {}
    end

    line.split(' ').each do |item|
     k, v = item.split(':')
      current[k] = v
    end
  end

  passports << current
end

def validate_date_field(value, min, max)
  (min..max).include? value.to_i
end

def validate_height(height)
  case height
  when /in$/
    (59..76).include? height.to_i
  when /cm$/
    (150..193).include? height.to_i
  end
end

def validate_hair_color(color)
  !!(/^#(\d|[a-f]){6}$/.match(color))
end

def validate_eye_color(color)
  ['amb', 'blu', 'brn', 'gry', 'grn', 'hzl', 'oth'].include?(color)
end

def validate_pid(pid)
  !!(/^\d{9}$/.match(pid))
end

def check_passport(passport)
  (
    validate_date_field(passport['byr'], 1920, 2002) &&
    validate_date_field(passport['iyr'], 2010, 2020) &&
    validate_date_field(passport['eyr'], 2020, 2030) &&
    validate_height(passport['hgt']) &&
    validate_hair_color(passport['hcl']) &&
    validate_eye_color(passport['ecl']) &&
    validate_pid(passport['pid'])
  )
end

passports = load_file('input.txt')

puts passports.map { |passport| check_passport(passport) }.count(true)
