input = File.read("#{__DIR__}/../input/22.txt")

example = "..#
#..
..."

# {0, 2}, {1, 2}, {2, 2}
# {0, 1}, {1, 1}, {2, 1}
# {0, 0}, {1, 0}, {2, 0}

def add_tuples(a, b)
  {a[0] + b[0], a[1] + b[1]}
end

def virus(input, limit)
  rows = input.split("\n").map { |x| x.split("") }
  graph = Hash(Tuple(Int32, Int32), Bool).new(false)
  middle = rows.size / 2

  rows.reverse.each_with_index do |row, y|
    row.each_with_index do |item, x|
      graph[{x, y}] = item == "#"
    end
  end

  curr = {middle, middle}
  direction = 0
  directions = [
    {0, 1},
    {1, 0},
    {0, -1},
    {-1, 0},
  ]
  count = 0
  infected = 0

  loop do
    if graph[curr]
      direction = (direction + 1) % 4
      graph[curr] = false
    else
      direction = (direction - 1) % 4
      graph[curr] = true
      infected += 1
    end
    curr = add_tuples(curr, directions[direction])
    count += 1

    if count >= limit
      return infected
    end
  end
end

puts "VIRUS"
puts virus(example, 7)     # 5
puts virus(example, 70)    # 41
puts virus(example, 10000) # 5587
puts virus(input, 10000)   # ?

enum States
  Clean
  Weakened
  Infected
  Flagged
end

def virus_harder(input, limit)
  rows = input.split("\n").map { |x| x.split("") }
  graph = Hash(Tuple(Int32, Int32), States).new(States::Clean)
  middle = rows.size / 2

  rows.reverse.each_with_index do |row, y|
    row.each_with_index do |item, x|
      graph[{x, y}] = item == "#" ? States::Infected : States::Clean
    end
  end

  curr = {middle, middle}
  direction = 0
  directions = [
    {0, 1},
    {1, 0},
    {0, -1},
    {-1, 0},
  ]
  count = 0
  infected = 0

  loop do
    case graph[curr]
    when States::Clean
      direction = (direction - 1) % 4
      graph[curr] = States::Weakened
    when States::Weakened
      graph[curr] = States::Infected
      infected += 1
    when States::Infected
      direction = (direction + 1) % 4
      graph[curr] = States::Flagged
    when States::Flagged
      direction = (direction + 2) % 4
      graph[curr] = States::Clean
    end

    curr = add_tuples(curr, directions[direction])
    count += 1

    if count >= limit
      return infected
    end
  end
end

puts "HARDER"
puts virus_harder(example, 100)      # 26
puts virus_harder(example, 10000000) # 2511944
puts virus_harder(input, 10000000)   # ?
