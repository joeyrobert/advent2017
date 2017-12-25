# From Advent 10
def knot_hash_bytes(lengths)
  rounds = 64
  curr = 0
  skip = 0
  numbers = 0.upto(255).to_a
  # puts numbers
  bytes = lengths.bytes + [17, 31, 73, 47, 23]

  rounds.times do |x|
    bytes.each do |length|
      selected = [] of Int32
      length.times do |i|
        selected << numbers[(curr + i) % numbers.size]
      end

      reversed = selected.reverse
      reversed.each_with_index do |value, i|
        numbers[(curr + i) % numbers.size] = value
      end

      curr = (curr + length + skip) % numbers.size
      skip += 1
      # puts numbers
    end
  end

  hsh = numbers.in_groups_of(16).map do |nums|
    nums.reduce(0) { |memo, num| memo ^ num.as(Int32) }
  end

  bytes = Bytes.new(16)

  hsh.each_with_index do |val, i|
    bytes[i] = val.to_u8
  end

  bytes.hexstring
end

def generate_disk(input)
  rows = [] of Array(Bool)
  0.upto(127) do |row_index|
    hsh = "#{input}-#{row_index}"
    hex = knot_hash_bytes(hsh).chars
    row = [] of Bool
    hex.each do |char|
      bytes = ("0" + char.to_s).hexbytes
      row << (bytes[0] & 8 > 0)
      row << (bytes[0] & 4 > 0)
      row << (bytes[0] & 2 > 0)
      row << (bytes[0] & 1 > 0)
    end
    rows << row
  end
  rows
end

def count_true(rows)
  count = 0
  rows.each do |row|
    row.each do |item|
      if item
        count += 1
      end
    end
  end
  count
end

def count_regions(rows)
  count = 0
  spoken_for = {} of Tuple(Int32, Int32) => Bool
  regions = [] of Array(Tuple(Int32, Int32))

  rows.each_with_index do |row, row_index|
    row.each_with_index do |value, col_index|
      pos = {row_index, col_index}
      if !value || spoken_for[pos]?
        next
      end

      next_pos = [pos] of Tuple(Int32, Int32)
      added = {pos => true}
      count += 1
      region = [] of Tuple(Int32, Int32)

      # Follow region iteratively
      while pos = next_pos.pop?
        value = rows[pos[0]][pos[1]]
        if !value
          next
        end

        region << pos
        spoken_for[pos] = true

        neighbors = [
          {pos[0] - 1, pos[1]},
          {pos[0] + 1, pos[1]},
          {pos[0], pos[1] - 1},
          {pos[0], pos[1] + 1},
        ]

        neighbors.each do |neighbor|
          if neighbor[0] >= 0 && neighbor[0] < 128 && neighbor[1] >= 0 && neighbor[1] < 128 && !added[neighbor]?
            next_pos << neighbor
            added[neighbor] = true
          end
        end
      end

      # puts region
      # regions << region
    end
  end

  # puts regions.size
  count
end

example = "flqrgnkx"
input = "hfdlxzhv"

puts "BITS"
puts count_true(generate_disk(example))
puts count_true(generate_disk(input))

puts "REGIONS"

puts count_regions(generate_disk(example))
puts count_regions(generate_disk(input))
