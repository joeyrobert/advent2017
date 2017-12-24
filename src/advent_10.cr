input = File.read("#{__DIR__}/../input/10.txt").split(',').map { |x| x.to_i }
input_raw = File.read("#{__DIR__}/../input/10.txt")

def knot_hash(lengths, list_max = 255)
  curr = 0
  skip = 0
  numbers = 0.upto(list_max).to_a
  # puts numbers

  lengths.each do |length|
    # Needs to wrap around
    # next_length = offset > numbers.size ? numbers.size - offset : offset

    # Select sections
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

  numbers[0] * numbers[1]
end

example = [3, 4, 1, 5]
puts knot_hash(example, 4)
puts knot_hash(input)

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

# example = [3, 4, 1, 5]
# puts knot_hash(example, 4)
puts knot_hash_bytes("")         # a2582a3a0e66e6e86e3812dcb672a272
puts knot_hash_bytes("AoC 2017") # 33efeb34ea91902bb2f59c9920caa6cd
puts knot_hash_bytes("1,2,3")    # 3efbe78a8d82f29979031a4aa0b16a9d
puts knot_hash_bytes("1,2,4")    # 63960835bcdc130f0b66d7ff4f6a5a8e
puts knot_hash_bytes(input_raw)  # ?
