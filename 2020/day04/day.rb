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
  value && value.length == 4 && value.to_i >= min && value.to_i <= max
end

def validate_height(height)
  return false unless height

  value = height[...-2].to_i
  units = height[-2..]

  if units == 'in'
    value >= 59 && value <= 76
  elsif units == 'cm'
    value >= 150 && value <= 193
  else
    false
  end
end

def validate_hair_color(color)
  color && !!(/^#(\d|[a-f]){6}$/.match(color))
end

def validate_eye_color(color)
  ['amb', 'blu', 'brn', 'gry', 'grn', 'hzl', 'oth'].include?(color)
end

def validate_pid(pid)
  pid && !!(/^\d{9}$/.match(pid))
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
