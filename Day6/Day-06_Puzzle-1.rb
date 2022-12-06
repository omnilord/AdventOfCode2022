File.readlines('Day-06_input.txt').map(&:chomp).each do |line|
  index = line.chars.each_cons(4).each_with_index { |chs, i| break i + 4 if chs.uniq.length == 4 }
  puts "#{line} => #{index}"
end
