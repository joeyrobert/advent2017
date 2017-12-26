input = File.read("#{__DIR__}/../input/21.txt")

example = "../.# => ##./#../...
.#./..#/### => #..#/..../..../#..#"

def parse_shape(shape)
  shape.split("/").map do |row|
    row.chars.map do |ch|
      case ch
      when '#'
        true
      when '.'
        false
      else
        raise Exception.new("Invalid Character: #{ch}")
      end
    end
  end
end

def shape_to_s(shape)
  shape.map do |row|
    row.map do |value|
      value ? "#" : "."
    end.join("")
  end.join("/")
end

def split_into_size(shape, size)
  shapes = [] of Array(Array(Bool))
  count = shape.size
  # puts "Shape #{shape.size} Size #{size} Count #{count}"
  x = 0
  while x < count
    y = 0
    while y < count
      chunk = [] of Array(Bool)
      i = 0

      # puts "#{x} #{y}"
      while i < size
        row = [] of Bool
        j = 0

        while j < size
          row << shape[x + i][y + j]
          j += 1
        end

        chunk << row
        i += 1
      end

      shapes << chunk
      y += size
    end
    x += size
  end

  shapes.to_a
end

def merge(shapes)
  final_shape = [] of Array(Bool)
  width = Math.sqrt(shapes.size).to_i
  sub_width = shapes[0].size

  full_width = width * sub_width

  full_width.times do
    final_shape << Array(Bool).new(full_width, false)
  end

  width.times do |x|
    width.times do |y|
      i = x * width + y
      shape = shapes[i]

      shape.each_with_index do |row, j|
        row.each_with_index do |item, k|
          final_shape[x * sub_width + j][y * sub_width + k] = item
        end
      end
    end
  end

  final_shape
end

def rotate(shape)
  shape.transpose
end

def horizontal_flip(shape)
  next_shape = [] of Array(Bool)
  shape.size.times do |x|
    row = [] of Bool
    shape.size.times do |y|
      row << shape[x][shape.size - y - 1]
    end
    next_shape << row
  end

  next_shape
end

def vertical_flip(shape)
  next_shape = [] of Array(Bool)
  shape.size.times do |x|
    row = [] of Bool
    shape.size.times do |y|
      row << shape[shape.size - x - 1][y]
    end
    next_shape << row
  end

  next_shape
end

def find_transition(transitions, shape)
  seen_before = {} of String => Bool
  shapes = [shape]

  # puts "SHAPE"
  # puts shape

  while s = shapes.shift?
    if seen_before[s]?
      next
    end

    if transitions[s]?
      return transitions[s]
    end
    # puts "BEFORE"
    # puts shapes

    seen_before[s] = true
    shapes << shape_to_s(rotate(parse_shape(s)))
    shapes << shape_to_s(vertical_flip(parse_shape(s)))
    shapes << shape_to_s(horizontal_flip(parse_shape(s)))

    # puts "AFTER"
    # puts shapes
  end

  raise Exception.new("No transition found: #{shape}")
end

def apply_transitions(transitions, shapes)
  shapes.map do |shape|
    transition = find_transition(transitions, shape_to_s(shape))
    parse_shape(transition)
  end
end

def parse_rules(rules, iterations)
  rules = rules.split("\n").map { |x| x.split(" => ") }
  transitions = {} of String => String
  rules.each do |rule|
    transitions[rule[0]] = rule[1]
  end
  # puts transitions

  shape = parse_shape(".#./..#/###")

  iterations.times do
    if shape.size % 2 == 0
      shape = merge(apply_transitions(transitions, split_into_size(shape, 2)))
    elsif shape.size % 3 == 0
      shape = merge(apply_transitions(transitions, split_into_size(shape, 3)))
    end
  end

  # puts "VALUE"
  # puts shape_to_s(merge(split_into_size(parse_shape(".#.###/..#.../###.../.#.###/..#.../###..."), 2)))
  # puts shape_to_s(shape)
  shape_to_s(shape).count('#')
end

puts parse_rules(example, 2)
puts "FIVE ITERATIONS"
puts parse_rules(input, 5)
puts "EIGHTEEN ITERATIONS"
puts parse_rules(input, 18)
