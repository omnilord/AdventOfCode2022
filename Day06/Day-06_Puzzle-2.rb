def detect_unique(msg, length: 4)
  msg.chars.each_cons(length).each_with_index { |chs, i| break i + length if chs.uniq.length == length }
end

File.readlines('Day-06_input.txt').map(&:chomp).each do |msg|
  index = detect_unique(msg, length: 14)
  puts "#{msg} => #{index}"
end
