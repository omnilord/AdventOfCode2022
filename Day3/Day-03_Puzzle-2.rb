PRIORITY = (('a'..'z').to_a + ('A'..'Z').to_a).freeze

total = File.readlines('Day-03_input.txt').map(&:chomp).each_slice(3).reduce(0) do |m, group|
  lookup = group.map(&:chars).reduce(&:&).first
  m + PRIORITY.find_index(lookup) + 1
end

puts total
