Instruction = Struct.new(:inst, :params)

Instructions = {
  'addx' => [ proc { |n| n.to_i }, proc { |n, last:| @registers[:x] += last }],
  'noop' => [ proc { next } ]
}.freeze

class CPU
  attr_reader :samples

  def initialize(program, screen)
    @program = program
    @screen = screen
    @registers = { x: 1 }
    @cycle = 1
    @state = :idle
    @inst = nil
    @load = nil
    @samples = []
  end

  def run
    tick while @state != :complete
  end

  def tick
    @cycle += 1
    @inst = @program.shift
    @last = instance_exec(*@inst.params, last: @last, &@inst.inst)
    @state = :complete if @cycle >= 500 || (@program.empty?)
    @screen.signal(@cycle, @registers[:x])
  end
end

class Screen
  def initialize
    @pixels = (1..240).map { '.' }
  end

  def signal(cycle, pos)
    @pixels[cycle - 1] = '#' if ((cycle - 1) % 40).between?(pos - 1, pos + 1)
  end

  def output
    @pixels.each_slice(40).map { |line| line.join('') }.join("\n")
  end
end

program = []
File.readlines('Day-10_input.txt').map do |line|
  /(\w{4})(?:\s+(\-?\d+))?/.match(line) do |m|
    Instructions[m[1]].each do |inst|
      program << Instruction.new(inst, [m[2]])
    end
  end
end


screen = Screen.new
cpu = CPU.new(program, screen)
cpu.run

puts screen.output
