class Monkey
  Monkeys = []

  attr_reader *%i[id inspections]

  def self.build(*config)
    Monkeys << Monkey.new(*config)
  end

  def self.[](id)
    Monkeys.find { |m| m.id == id }
  end

  def self.rounds(n, reporting = false)
    n.times do |round|
      r = round + 1
      #print ".#{r}" if (r % 100).zero?
      puts "\n############### ROUND #{r} ###############\n" if reporting && (r % 100).zero?
      Monkeys.each(&:turn)
      Monkeys.each(&:report) if reporting && (r % 100).zero?
    end
  end

  def self.business
    Monkey::Monkeys.map(&:inspections).sort.pop(2).reduce(:*)
  end

  def initialize(*config)
    @id = config[0].match(/Monkey (\d+):/) { |m| m[1] }
    @inventory = config[1].scan(/\d+/)
    @operation = config[2].match(/Operation: new = (.+)/) { |m| parse_op(m[1]) }
    @test = config[3].match(/Test: divisible by (\d+)/) { |m| parse_test(m[1].to_i) }
    @results = {
      true => config[4].match(/throw to monkey (\d+)/) { |m| parse_throw(m[1]) },
      false => config[5].match(/throw to monkey (\d+)/) { |m| parse_throw(m[1]) }
    }.freeze
    @inspections = 0
  end

  def turn
    while item = @inventory.shift
      @inspections += 1
      worry = @operation.call(item)
      result = @test.call(worry)
      @results[result].call(worry)
    end
  end

  def pass(item)
    @inventory << item
  end

  def report
    puts "Monkey #{@id}: #{@inspections}"
  end

private

  def parse_op(value) = proc { |n| eval(value.gsub('old', n.to_s)) }
  def parse_test(value) =  proc { |item| (item % value).zero? }
  def parse_throw(value) = proc { |item| Monkey[value].pass(item) }
end

File.readlines('Day-11_input.txt').map(&:chomp).each_slice(7) do |lines|
  Monkey.build(*lines)
end

Monkey.rounds(10_000, true)

puts "\nMonkey Business: #{Monkey.business}\n"
