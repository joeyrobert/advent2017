input = File.read_lines("#{__DIR__}/../input/12.txt")

example = "0 <-> 2
1 <-> 1
2 <-> 0, 3, 4
3 <-> 2, 4
4 <-> 2, 3, 6
5 <-> 6
6 <-> 4, 5".split('\n')

def connected_programs(input)
  programs = {} of String => Array(String)
  input.each do |line|
    components = line.split(' ')
    program, operator = components[0], components[1]
    connected = line.split(" <-> ")[1].split(", ")
    programs[program] = connected
  end

  next_node = ["0"]
  visited = ["0"] of String
  while node = next_node.shift?
    # puts node
    next_node += (programs[node] - visited)
    before_size = visited.size
    visited = (visited + programs[node]).uniq
    after_size = visited.size
  end

  visited.size
end

puts "GROUP SIZE"
puts connected_programs(example)
puts connected_programs(input)

def connected_groups(input)
  programs = {} of String => Array(String)
  input.each do |line|
    components = line.split(' ')
    program, operator = components[0], components[1]
    connected = line.split(" <-> ")[1].split(", ")
    programs[program] = connected
  end

  all = {} of String => Bool
  spoken_for = {} of String => Bool
  programs.each_key do |program|
    if spoken_for[program]?
      next
    end

    next_node = [program]
    visited = [program] of String
    while node = next_node.shift?
      # puts node
      next_node += (programs[node] - visited)
      before_size = visited.size
      visited = (visited + programs[node]).uniq
      after_size = visited.size
    end

    visited.each do |prog|
      spoken_for[prog] = true
    end

    all[visited.sort.to_s] = true
  end

  all.size
end

puts "NUMBER OF GROUPS"
puts connected_groups(example)
puts connected_groups(input)
