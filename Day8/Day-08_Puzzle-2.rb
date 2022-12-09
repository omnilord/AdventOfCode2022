require 'awesome_print'

class Grid
  GridCell = Struct.new(:x, :y, :size, :grid, :score) do
    def to_s = self.seen ? 'X' : ' '
    def inspect = "< GridCell x=#{self.x} y=#{self.y} size=#{self.size} score=#{self.score} >"
    def <(other) = self.size < other.size
    def <=(other) = self.size <= other.size

    def score!
      self.score ||= begin
        [
          self.grid.walk((self.x - 1).downto(0), [self.y], self),
          self.grid.walk((self.x + 1).upto(self.grid.x_size - 1), [self.y], self),
          self.grid.walk([self.x], (self.y - 1).downto(0), self),
          self.grid.walk([self.x], (self.y + 1).upto(self.grid.y_size - 1), self),
        ].reduce(:*)
      end
    end
  end

  attr_reader :grid, :x_size, :y_size

  def initialize(file)
    @y_size = 0

    @grid = File.readlines(file).map(&:chomp).each_with_index.map do |line, x|
      @y_size = line.length if line.length > @y_size

      line.chars.each_with_index.map do |ch, y|
        GridCell.new(x, y, ch.to_i, self, nil)
      end
    end

    @x_size = @grid.length
  end

  def to_s = @grid.map { |row| row.map(&:to_s).join }.join("\n")
  def inspect = "< Grid x_size=#{@x_size} y_size=#{@y_size} grid=#{@grid.inspect} >"

  def walk(xs, ys, tree)
# REVIEW: why does this work without the commented out logic?

    catch(:blocked) do
#      max = nil

      xs.reduce(0) do |m, x|
        m + ys.reduce(0) do |n, y|
          sighted = @grid[x][y]

          throw :blocked, m + n + 1 if tree <= sighted

#          next n if !max.nil? && sighted < max

#          max = sighted if max.nil? || max < sighted

          n + 1
        end
      end
    end
  end
end

grid = Grid.new('Day-08_input.txt')

scores = grid.grid.flatten.map(&:score!)

max = scores.max

puts "Best Scenic Score: #{max}"
