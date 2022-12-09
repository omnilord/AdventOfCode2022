class Grid
  GridCell = Struct.new(:x, :y, :size, :seen) do
    def to_s = self.seen ? 'X' : ' '
    def inspect = "< GridCell x=#{self.x} y=#{self.y} size=#{self.size} seen=#{self.seen} >"
    def <(other) = self.size < other.size
    def see! = self.seen = true
  end

  attr_reader :count, :grid, :x_size, :y_size

  def initialize(file)
    populate_grid(file)
    initialize_seen

    @count = @grid.flatten.count(&:seen)
  end

  def to_s = @grid.map { |row| row.map(&:to_s).join }.join("\n")
  def inspect = "< Grid x_size=#{@x_size} y_size=#{@y_size} count=#{@count} grid=#{@grid.inspect} >"

private

  def populate_grid(file)
    @y_size = 0

    @grid = File.readlines(file).map(&:chomp).each_with_index.map do |line, x|
      @y_size = line.length if line.length > @y_size

      line.chars.each_with_index.map do |ch, y|
        GridCell.new(x, y, ch.to_i, false)
      end
    end

    @x_size = @grid.length
  end

  def initialize_seen
    @grid[0].each(&:see!)
    @grid.last.each(&:see!)

    @grid.each do |row|
      row.first.see!
      row.last.see!
    end

    x_end = @x_size - 1
    y_end = @y_size - 1
    x_indexes = (1...x_end).to_a
    y_indexes = (1...y_end).to_a

    scan_grid(x_indexes, y_indexes, 0, 0)
    scan_grid(x_indexes.reverse, y_indexes.reverse, x_end, y_end)
  end

  def scan_grid(x_indexes, y_indexes, x_start, y_start)
    y_maxes = @grid[x_start].dup

    x_indexes.each do |x|
      x_max = @grid[x][y_start]

      y_indexes.each do |y|
        tree = @grid[x][y]

        if x_max < tree
          tree.see!
          x_max = tree
        end

        if y_maxes[y] < tree
          tree.see!
          y_maxes[y] = tree
        end
      end
    end
  end
end

grid = Grid.new('Day-08_input.txt')

puts grid
puts "Trees: #{grid.count}"

