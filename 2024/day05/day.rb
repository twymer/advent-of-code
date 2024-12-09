def load_file(filename = 'input.txt')
  rows = File.open(filename).readlines.map(&:chomp)
  split_at = rows.index('')

  rules = convert_rules(rows[0...split_at])
  updates = rows[(split_at + 1)..].map { |instruction| instruction.split(',') }

  [rules, updates]
end

def convert_rules(rules_strings)
  rules_strings.inject({}) do |rules, rule_string|
    a, b = rule_string.split('|')
    if rules.key?(a)
      rules[a] << b
    else
      rules[a] = [b]
    end
    rules
  end
end

def validate_rules(update, rules)
  update.each_with_index.all? do |page, i|
    if rules.key? page
      reqs = rules[page]

      reqs.all? do |req|
        if update.include? req
          (update.count - 1 - update.reverse.index(req)) > i
        else
          true
        end
      end
    else
      true
    end
  end
end

rules, updates = load_file

result = updates.filter do |update|
  validate_rules(update, rules)
end.inject(0) do |sum, row|
  sum + row[row.count / 2].to_i
end

puts result
#
# puts validate_rules(["75","47","61","53","29"], rules)
# puts validate_rules(["61","13","29"], rules)

