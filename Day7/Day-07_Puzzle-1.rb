class String
  # Barrowing String#indent from ActiveSupport 5.2.3

  def indent!(amount, indent_string = nil, indent_empty_lines = false)
    indent_string = indent_string || self[/^[ \t]/] || " "
    re = indent_empty_lines ? /^/ : /^(?!$)/
    gsub!(re, indent_string * amount)
  end

  def indent(amount, indent_string = nil, indent_empty_lines = false)
    dup.tap { |_| _.indent!(amount, indent_string, indent_empty_lines) }
  end
end


class FileNode
  attr_reader :name, :parent, :size, :type

  def initialize(name, parent, size)
    @name = name
    @parent = parent
    @size = size.to_i
    @type = :file
  end

  def to_s
    "- #{name} (file, size=#{size})"
  end

  def dir? = false
  def file? = true
end


class DirNode
  attr_reader :name, :parent, :type

  def initialize(name, parent: '/')
    @name = name
    @parent = parent
    @children = {}
    @type = :dir
  end

  def to_s
    ["- #{name} (dir, virtual_size=#{size})", *children.map { |child| child.to_s.indent(2) }].join("\n")
  end

  def dir? = true
  def file? = false

  def children
    @children.values.sort_by(&:name)
  end

  def size = @total_size ||= children.reduce(0) { |m, child| m + child.size }

  def traverse(dir)
    return parent if dir == '..'
    return Root if dir == '/'

    child_dir(dir)
  end

  def child_dir(name)
    upsert_child_node(name) { DirNode.new(name, parent: self) }
  end

  def add_file(name, size)
    upsert_child_node(name) { FileNode.new(name, self, size) }
  end

  def walk_dirs_reduce(init, &block)

    flatten_dirs.reduce(init, &block)
  end

  def flatten_dirs
    child_dirs = @children.values.filter(&:dir?)
    [*child_dirs, *child_dirs.map(&:flatten_dirs).flatten]
  end

private

  def upsert_child_node(name)
    if @children[name].nil?
      @children[name] = yield
      @total_size = nil
    end

    @children[name]
  end
end

cursor = Root = DirNode.new('/', parent: nil)

# step 1 - build tree from input

File.readlines('Day-07_input.txt').map(&:chomp).each do |line|
  if line.start_with?('$ cd')
    dirname = line[5..].strip
    cursor = cursor.traverse(dirname)
  elsif m = line.match(/^(\d+) ([\w\.]+)$/)
    cursor.add_file(m[2], m[1])
  end
end


# step 2 - walk tree for output

total = Root.walk_dirs_reduce(0) { |m, dir| m + (dir.size <= 100_000 ? dir.size : 0) }

puts "Total: #{total}"
