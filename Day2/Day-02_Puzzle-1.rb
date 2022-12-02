# A => rock (1)
# B => paper (2)
# C => scissors (3)
# X => rock (1)
# Y => paper (2)
# Z => scissors (3)

SCORES = {
  'A X' => 4,
  'A Y' => 8,
  'A Z' => 3,
  'B X' => 1,
  'B Y' => 5,
  'B Z' => 9,
  'C X' => 7,
  'C Y' => 2,
  'C Z' => 6
}.freeze

total = File.readlines('Day-02_input.txt').map(&:chomp).reduce(0) { |m, line| m + SCORES[line] }

puts total
