largest = File.readlines('Day-01_input.txt')
  .map(&:chomp)
  .slice_when { |item| item.empty? }
  .map { |elf| elf.map(&:to_i).reduce(:+) }
  .max

puts largest
