def index_to_coordinates(input)
  number_to_coords = [{0, 0}, {0, 0}]
  coords = {0, 0}

  deltas = [
    {1, 0},
    {0, 1},
    {-1, 0},
    {0, -1}
  ]

  1.upto(input) do |number|
    offset = (number.to_f / 2.0).ceil.to_i
    delta = deltas[(number - 1) % 4]

    offset.times do |i|
      coords = {
        coords[0] + delta[0],
        coords[1] + delta[1]
      }
      number_to_coords << coords

      if number_to_coords.size > input
        return number_to_coords[input].map { |x| x.abs }.sum
      end
    end
  end

  number_to_coords[input].map { |x| x.abs }.sum
end

puts "CIRCULAR"
puts index_to_coordinates(1)
puts index_to_coordinates(12)
puts index_to_coordinates(23)
puts index_to_coordinates(1024)
puts index_to_coordinates(312051)

def stress_test(input)
  number = 1
  delta_index = 0
  coords_to_numbers = { {0, 0} => 1}
  coords = {0, 0}
  offset = 0.0
  deltas = [
    {1, 0},
    {0, 1},
    {-1, 0},
    {0, -1}
  ]
  neighbors = [
    {1, -1},
    {1, 0},
    {1, 1},
    {0, 1},
    {-1, 1},
    {-1, 0},
    {-1, -1},
    {0, -1}
  ]

  loop do
    offset = offset += 0.5
    delta = deltas[delta_index % 4]
    delta_index += 1

    # puts offset

    offset.ceil.to_i.times do |i|
      number += 1
      coords = {
        coords[0] + delta[0],
        coords[1] + delta[1]
      }

      neighbor_sum = neighbors.reduce(0) do |memo, neighbor_delta|
        neighbor_coords = {
          coords[0] + neighbor_delta[0],
          coords[1] + neighbor_delta[1]
        }
        memo + (coords_to_numbers[neighbor_coords]? || 0)
      end

      coords_to_numbers[coords] = neighbor_sum

      if neighbor_sum > input
        return neighbor_sum
      end
    end
  end
end

puts "STRESS TEST"

puts stress_test(805) # 806
puts stress_test(312051)
