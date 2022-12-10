CRATES_REGEX = /(\s{4}|\[\w\])/
PLAN_REGEX = /move (?<move>\d+) from (?<from>\d+) to (?<to>\d+)/

Crates = Hash.new { |h, k| h[k] = Array.new }
Plans = []

def parse_container(line)
  line.scan(CRATES_REGEX).each_with_index do |value, i|
    crate = value.first.gsub(/[^\w]/, '')
    Crates[(i + 1).to_s] << crate unless crate.empty?
  end
end

def parse_instruction(line)
  Plans << line.match(PLAN_REGEX)
end

output = File.readlines('Day-05_input.txt').map do |line|
  parse_container(line) if line.match?(CRATES_REGEX)
  parse_instruction(line) if line.match?(PLAN_REGEX)
end

Plans.each do |plan|
  Crates[plan[:to]].unshift *Crates[plan[:from]].shift(plan[:move].to_i)
end


output = Crates.keys.sort.reduce('') { |m, n| m + Crates[n].first }

puts output
