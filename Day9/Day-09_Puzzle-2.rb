require 'awesome_print'

Coord = Struct.new(:ch, :x, :y, :parent, :child, :last) do
  def to_s = self.ch
  def inspect = "< Coord x=#{self.x} y=#{self.y} ch=#{self.ch} parent=#{self.parent} child=#{self.child} last=#{self.last} >"
  def ==(other) = self.x == other.x && self.y == other.y
  def coords = "#{self.x},#{self.y}"

  def +(other)
    self.last = nil

    Coord.new(
      self.ch,
      self.x + (other.respond_to?(:x) ? other.x : other[0]),
      self.y + (other.respond_to?(:y) ? other.y : other[1]),
      self.parent,
      self.child,
      self
    )
  end

  def follow(other)
    dx = self.x - other.x
    dy = self.y - other.y
    change = dx.abs + dy.abs

    return false if change < 2

    new_x = other.last.x if dy.zero? || change == 3
    new_y = other.last.y if dx.zero? || change == 3

    unless new_x.nil? && new_y.nil?
      self.last = Coord.new(self.ch, self.x, self.y, self.parent, self.child)
      self.x = new_x unless new_x.nil?
      self.y = new_y unless new_y.nil?
    end

    true
  end
end

Shifts = {
  'U' => [0, 1].freeze,
  'D' => [0, -1].freeze,
  'L' => [-1, 0].freeze,
  'R' => [1, 0].freeze
}.freeze

INIT_X = 11
INIT_Y = 5
Start = Coord.new('s', INIT_X, INIT_Y)
Knots = (1..9).reduce([Coord.new('H', INIT_X, INIT_Y)]) { |m, ch| m.concat([m.last.child = Coord.new(ch.to_s, INIT_X, INIT_Y, m.last)]) }
Visits = Hash.new { |h, k| h[k] = 0 }
Visits[Start.coords] += 1

def print_board
  grid = (0..20).map do |y|
    (0..25).map do |x|
      this = Coord.new('.', x, y)
      Knots.find { |knot| knot == this } || this
    end.join('')
  end.reverse.join("\n")

  puts "\n#{grid}\n"
end

print_board

def move_knots
  Knots.each_cons(2).reduce(true) do |m, knots|
    m && knots.last.follow(knots.first)
  end
end

Instructions = File.readlines('Day-09_input.txt').map do |line|
  line.match(/([RLUD]) (\d+)/) do |m|
    m[2].to_i.times do
      Knots[0] += Shifts[m[1]]
      Visits[Knots.last.coords] += 1 if move_knots
      #print_board
    end
  end
end


puts "Visits: #{Visits.length}"
