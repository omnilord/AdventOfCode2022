PAIR_REGEX = /^(?<p1>\d+)\-(?<p2>\d+),(?<p3>\d+)\-(?<p4>\d+)$/

def parse_pairs(line)
  match = PAIR_REGEX.match(line)
  {
    elf1: (match[:p1].to_i..match[:p2].to_i).to_a,
    elf2: (match[:p3].to_i..match[:p4].to_i).to_a,
  }
end

output = File.readlines('Day-04_input.txt').map { |line| parse_pairs(line) }.select do |pairs|
  intersect = pairs[:elf1] & pairs[:elf2]
  intersect == pairs[:elf1] || intersect == pairs[:elf2]
end.length

puts "Solution: #{output}"
