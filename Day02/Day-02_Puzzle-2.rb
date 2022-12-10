# A => rock (1)
# B => paper (2)
# C => scissors (3)
# X => lose (0)
# Y => draw (3)
# Z => win (6)

SCORES = {
  'A X' => 3,
  'A Y' => 4,
  'A Z' => 8,
  'B X' => 1,
  'B Y' => 5,
  'B Z' => 9,
  'C X' => 2,
  'C Y' => 6,
  'C Z' => 7
}.freeze

total = File.readlines('Day-02_input.txt').map(&:chomp).reduce(0) { |m, line| m + SCORES[line] }

puts total
