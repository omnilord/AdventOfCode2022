Coord = Struct.new(:x, :y, :last) do
  def +(other)
    self.last = nil

    Coord.new(
      self.x + (other.respond_to?(:x) ? other.x : other[0]),
      self.y + (other.respond_to?(:y) ? other.y : other[1]),
      self
    )
  end

  def follow(other)
    dx = self.x - other.x
    dy = self.y - other.y
    change = dx.abs + dy.abs

    return false if change < 2

    self.x = other.last.x if dy.zero? || change == 3
    self.y = other.last.y if dx.zero? || change == 3

    true
  end
end

Shifts = {
  'U' => [0, 1].freeze,
  'D' => [0, -1].freeze,
  'L' => [-1, 0].freeze,
  'R' => [1, 0].freeze
}.freeze

Visits = Hash.new { |h, k| h[k] = 0 }
Visits['0,0'] += 1

h_cursor = Coord.new(0, 0)
t_cursor = Coord.new(0, 0)

Instructions = File.readlines('Day-09_input.txt').map do |line|
  line.match(/([RLUD]) (\d+)/) do |m|
    m[2].to_i.times do
      h_cursor += Shifts[m[1]]
      Visits["#{t_cursor.x},#{t_cursor.y}"] += 1 if t_cursor.follow(h_cursor)
    end
  end
end

puts "\nVisits: #{Visits.length}\n"
