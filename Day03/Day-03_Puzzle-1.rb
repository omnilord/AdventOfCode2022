PRIORITY = (('a'..'z').to_a + ('A'..'Z').to_a).freeze

total = File.readlines('Day-03_input.txt').map(&:chomp).reduce(0) do |m, line|
  c1, c2 = line.chars.each_slice(line.length / 2).map(&:to_a)
  lookup = (c1 & c2).first
  m + PRIORITY.find_index(lookup) + 1
end

puts total
