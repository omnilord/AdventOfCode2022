require 'awesome_print'

Instruction = Struct.new(:inst, :params)

Instructions = {
  'addx' => [ proc { |n| n.to_i }, proc { |n, last:| @registers[:x] += last }],
  'noop' => [ proc { next } ]
}.freeze

class CPU
  attr_reader :samples

  def initialize(program)
    @program = program
    @registers = { x: 1 }
    @cycle = 1
    @state = :idle
    @inst = nil
    @load = nil
    @samples = []
  end

  def run(&block)
    tick(&block) while @state != :complete
  end

  def tick
    @cycle += 1
    @inst = @program.shift
    @last = instance_exec(*@inst.params, last: @last, &@inst.inst)
    @state = :complete if @cycle >= 500 || (@program.empty?)

    sample_cycle = (@cycle - 20) % 40
    @samples << @cycle * @registers[:x] if sample_cycle.zero?
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

cpu = CPU.new(program)

cpu.run

ap cpu.samples

puts "Total: #{cpu.samples.reduce(:+)}"
