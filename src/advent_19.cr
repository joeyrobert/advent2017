example = "     |
     |  +--+
     A  |  C
 F---|----E|--+
     |  |  |  D
     +B-+  +--+
"

input = File.read("#{__DIR__}/../input/19.txt")

def add_tuples(a, b)
  {a[0] + b[0], a[1] + b[1]}
end

def valid_square(value)
  ["-", "|", "+"].includes?(value) || /[A-Z]/ =~ value
end

def follow_path(path)
  lines = path.split("\n").map { |line| line.split("") }
  # puts lines

  # Starting position
  index = lines[0].index("|") || 0
  pos = {0, index}
  direction = {1, 0}
  letters = [] of String
  steps = 1

  directions = [
    {1, 0},
    {0, 1},
    {-1, 0},
    {0, -1},
  ]

  opposites = {
    {1, 0}  => {-1, 0},
    {0, 1}  => {0, -1},
    {-1, 0} => {1, 0},
    {0, -1} => {0, 1},
  }

  loop do
    pos = add_tuples(pos, direction)
    value = lines[pos[0]][pos[1]]
    # puts "#{pos} = #{value}"
    # sleep 0.1
    steps += 1

    if /[A-Z]/ =~ value
      letters << value
    end

    # Check next position, change direction accordingly
    next_pos = add_tuples(pos, direction)

    # Default to invalid character is position is invalid
    next_value = begin
      lines[next_pos[0]][next_pos[1]]
    rescue
      " "
    end

    if !valid_square(next_value)
      # Find a valid direction
      possible = directions - [direction, opposites[direction]]
      next_direction = direction
      possible.each do |dir|
        possible_pos = add_tuples(pos, dir)

        possible_value = begin
          lines[possible_pos[0]][possible_pos[1]]
        rescue
          " "
        end

        if valid_square(possible_value)
          next_direction = dir
          break
        end
      end

      if next_direction == direction
        break
      else
        direction = next_direction
      end
    end
  end

  {letters.join, steps}
end

puts follow_path(example)
puts follow_path(input)
