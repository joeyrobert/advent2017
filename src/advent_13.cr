input = File.read_lines("#{__DIR__}/../input/13.txt")

example = "0: 3
1: 2
4: 4
6: 4".split('\n')

class Node
  property depth
  property range
  property direction
  property index

  def initialize(@depth : Int32,
                 @range : Int32,
                 @direction : Int32,
                 @index : Int32)
  end

  def next!
    @index += @direction
    if @index == 0 || @index == @range - 1
      @direction *= -1
    end
  end
end

def construct_firewall(input)
  firewall = {} of Int32 => Node
  max_depth = 0

  # Initial states
  input.each do |row|
    depth, range = row.split(": ").map { |x| x.to_i }
    max_depth = [max_depth, depth].max
    firewall[depth] = Node.new(depth, range, 1, 0)
  end

  {firewall, max_depth}
end

def firewall_severity(firewall, max_depth)
  severity = 0

  0.upto(max_depth) do |depth|
    node = firewall[depth]?
    if node && node.index == 0
      severity += node.depth * node.range
    end

    # Update firewall
    firewall.each_value do |node|
      node.next!
    end
  end

  severity
end

def firewall_caught(firewall, max_depth)
  caught = false

  0.upto(max_depth) do |depth|
    node = firewall[depth]?
    if node && node.index == 0
      return true
    end

    # Update firewall
    firewall.each_value do |node|
      node.next!
    end
  end

  false
end

def firewall_severity_for_input(input)
  firewall, max_depth = construct_firewall(input)
  firewall_severity(firewall, max_depth)
end

def clone_firewall(firewall)
  cloned_firewall = {} of Int32 => Node
  firewall.each do |k, v|
    cloned_firewall[k] = Node.new(v.depth, v.range, v.direction, v.index)
  end
  cloned_firewall
end

def bypass_firewall(input)
  delay = 0
  firewall, max_depth = construct_firewall(input)

  loop do
    if !firewall_caught(clone_firewall(firewall), max_depth)
      return delay
    end

    # Update firewall
    firewall.each_value do |node|
      node.next!
    end

    delay += 1
  end
end

puts "SEVERITY"
puts firewall_severity_for_input(example)
puts firewall_severity_for_input(input)

puts "BYPASS DELAY"
puts bypass_firewall(example)
puts bypass_firewall(input)
