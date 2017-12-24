input = File.read("#{__DIR__}/../input/11.txt")

def add_tuples(a, b)
  {a[0] + b[0], a[1] + b[1]}
end

def subtract_tuples(a, b)
  {a[0] - b[0], a[1] - b[1]}
end

def cube_to_evenq(cube)
  col = cube[0]
  row = cube[2] + (cube[0] + (cube[0] & 1)) / 2
  {col, row}
end

def evenq_to_cube(hex)
  x = hex[0]
  z = hex[1] - (hex[0] + (hex[0] & 1)) / 2
  y = -x - z
  {x, y, z}
end

def hex_distance(a, b)
  a = evenq_to_cube(a)
  b = evenq_to_cube(b)
  ((a[0] - b[0]).abs + (a[1] - b[1]).abs + (a[2] - b[2]).abs) / 2
end

def get_neighbor(coords, direction)
  # Using even-q horizontal layout
  # https://www.redblobgames.com/grids/hexagons/
  neighbor_deltas = {
    "nw" => {-1, 0}, # nw
    "n"  => {0, -1}, # n
    "ne" => {1, 0},  # ne
    "se" => {1, 1},  # se
    "s"  => {0, 1},  # s
    "sw" => {-1, 1}, # sw
  }

  delta = case direction
          when "nw"
            coords[0].odd? ? {-1, -1} : {-1, 0}
          when "n"
            {0, -1}
          when "ne"
            coords[0].odd? ? {1, -1} : {1, 0}
          when "se"
            coords[0].odd? ? {1, 0} : {1, 1}
          when "s"
            {0, 1}
          when "sw"
            coords[0].odd? ? {-1, 0} : {-1, 1}
          else
            {0, 0}
          end

  add_tuples(coords, delta)
end

def get_directions(coords)
  # puts coords
  directions = [] of String

  if coords[0] < 0
    directions += ["nw", "sw"]
  end

  if coords[0] > 0
    directions += ["ne", "se"]
  end

  if coords[1] < 0
    directions += ["ne", "nw", "n"]
  end

  if coords[1] > 0
    directions += ["se", "sw", "s"]
  end

  directions.uniq!
  directions
end

def shortest_steps(path)
  coords = {0, 0}

  path.split(',').each do |direction|
    coords = get_neighbor(coords, direction)
  end

  # distance_to(coords)
  hex_distance(coords, {0, 0})
end

# dijkstra / breadth first
def distance_to(coords)
  node = {0, 0}
  distances = {} of Tuple(Int32, Int32) => Int32
  visited = {} of Tuple(Int32, Int32) => Bool
  next_nodes = [] of Tuple(Int32, Int32)
  next_visited = {} of Tuple(Int32, Int32) => Bool
  distances[node] = 0

  while node != coords
    directions = get_directions(subtract_tuples(coords, node))

    neighbors = directions.map do |direction|
      neighbor = get_neighbor(node, direction)
    end

    neighbors.select! do |neighbor|
      hex_distance(neighbor, coords) < hex_distance(node, coords)
    end

    neighbors.each do |neighbor|
      if visited[neighbor]?.nil?
        distances[neighbor] = [
          distances[neighbor]? || Int32::MAX,
          distances[node] + 1,
        ].min
        if !next_visited[neighbor]?
          next_nodes << neighbor
          next_visited[neighbor] = true
        end
      end
    end

    visited[node] = true
    node = next_nodes.shift
  end

  distances[coords]
end

def max_distance(path)
  max = 0
  coords = {0, 0}
  components = path.split(',')

  components.each_with_index do |direction, i|
    coords = get_neighbor(coords, direction)
    # puts "#{i} / #{components.size}"
    max = [max, distance_to(coords)].max
  end

  max
end

def max_distance_online(path)
  max = 0
  coords = {0, 0}
  node = {0, 0}
  components = path.split(',')

  components.each_with_index do |direction, i|
    coords = get_neighbor(coords, direction)
    # puts "#{i} / #{components.size}"
    max = [max, hex_distance(coords, {0, 0})].max
  end

  max
end

puts shortest_steps("ne,ne,ne")       # 3
puts shortest_steps("ne,ne,sw,sw")    # 0
puts shortest_steps("ne,ne,s,s")      # 2
puts shortest_steps("se,sw,se,sw,sw") # 3
puts shortest_steps(input)            # ?
puts max_distance_online(input)       # ?
