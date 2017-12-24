input = File.read_lines("#{__DIR__}/../input/07.txt")

example = "pbga (66)
xhth (57)
ebii (61)
havc (66)
ktlj (57)
fwft (72) -> ktlj, cntj, xhth
qoyq (66)
padx (45) -> pbga, havc, qoyq
tknk (41) -> ugml, padx, fwft
jptl (61)
ugml (68) -> gyxo, ebii, jptl
gyxo (61)
cntj (57)".split("\n")

def get_bottom_node(tower)
  # puts tower
  child_to_parent = {} of String => String
  nodes = [] of String
  tower.each do |node|
    items = node.split(" ")
    parent = items[0]
    # puts parent
    nodes << parent
    weight = items[1][1..-2].to_i
    # weight = items[1][1,-1]
    has_children = items.size > 2 && items[2] == "->"
    children = has_children ? node.split(" -> ")[1].split(", ") : [] of String

    children.each do |child|
      child_to_parent[child] = parent
    end
  end

  nodes.find {|x| child_to_parent[x]?.nil? }
end

puts "BOTTOM NODE"
puts get_bottom_node(example)
puts get_bottom_node(input)

def get_program_weight(tower)
  # puts tower
  child_to_parent = {} of String => String
  parent_to_children = {} of String => Array(String)
  weight_of_children =
  weight_by_id = {} of String => Int32
  nodes = [] of String
  tower.each do |node|
    items = node.split(" ")
    parent = items[0]
    # puts parent
    nodes << parent
    weight = items[1][1..-2].to_i
    # puts "#{weight} = #{items[1][1..-2]}"
    weight_by_id[parent] = weight
    # weight = items[1][1,-1]
    has_children = items.size > 2 && items[2] == "->"
    children = has_children ? node.split(" -> ")[1].split(", ") : [] of String

    children.each do |child|
      child_to_parent[child] = parent
    end
    parent_to_children[parent] = children
  end

  bottom_node = nodes.find {|x| child_to_parent[x]?.nil? } || ""
  weight, children_weight_by_id = children_weight(bottom_node, parent_to_children, weight_by_id.clone)

  # Visualize children weight by ID
  # puts PrettyPrint.format(visualize_children(bottom_node, parent_to_children, children_weight_by_id), STDOUT, 79)
  # puts PrettyPrint.format(visualize_children(bottom_node, parent_to_children, weight_by_id), STDOUT, 79)
  # puts weight_by_id
  # puts children_weight_by_id
  children_equality(bottom_node, parent_to_children, children_weight_by_id, weight_by_id)[-1]
end

struct Node
  property node, weight, children

  def initialize(@node : String, @weight : Int32, @children : Array(Node))
  end
end

def visualize_children(node, parent_to_children, weight_by_id) : Node
  children = parent_to_children[node]? || [] of String
  Node.new(node, weight_by_id[node], children.map{|child| visualize_children(child, parent_to_children, weight_by_id).as(Node)}.to_a)
end

def children_weight(node, parent_to_children, weight_by_id)
  weight = weight_by_id[node]
  children = parent_to_children[node]? || [] of String
  children.each do |child|
    weight += children_weight(child, parent_to_children, weight_by_id)[0]
  end
  weight_by_id[node] = weight
  {weight, weight_by_id}
end

def children_equality(node, parent_to_children, children_weight_by_id, weight_by_id)
  children = parent_to_children[node]? || [] of String
  children_weights = [] of Int32
  weights = [] of Int32
  offending = [] of Int32
  children.each do |child|
    child_weight = children_weight_by_id[child]
    weights << weight_by_id[child]
    children_weights << child_weight
  end
  children_weights.each_with_index do |child_weight, i|
    count = children_weights.count { |x| x == child_weight }
    if count == 1 && children.size > 1
      # puts children[i]
      # puts children_weights
      offending << weights[i] + (children_weights[(i + 1) % children_weights.size] - child_weight)
    end
  end

  children.each do |child|
    offending += children_equality(child, parent_to_children, children_weight_by_id, weight_by_id)
  end

  offending
end

puts "PROGRAM WEIGHT"
puts get_program_weight(example)
puts get_program_weight(input)
