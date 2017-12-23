input = File.read("#{__DIR__}/../input/01.txt")

def advent(input)
  sum = 0
  input.each_char_with_index do |char, index|
    if char == input[(index + 1) % input.size]
      sum += char.to_i
    end
  end
  sum
end

puts "DAY"
puts advent(input)
puts advent("1122")
puts advent("1111")
puts advent("91212129")

def advent_circular(input)
  sum = 0
  input.each_char_with_index do |char, index|
    if char == input[(index + input.size / 2) % input.size]
      sum += char.to_i
    end
  end
  sum
end

puts "CIRCULAR"
puts advent_circular(input)
puts advent_circular("1212")
puts advent_circular("1221")
puts advent_circular("123425")
puts advent_circular("123123")
puts advent_circular("12131415")
