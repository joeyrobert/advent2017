input = File.read_lines("#{__DIR__}/../input/02.txt")

def compute_checksum(input)
  checksum = 0
  input.each do |row|
    numeric_row = row.split("\t").map { |x| x.to_i }.to_a
    checksum += numeric_row.max - numeric_row.min
  end
  checksum
end

example = [
  "5\t1\t9\t5",
  "7\t5\t3",
  "2\t4\t6\t8"
]
puts "COMPUTE CHECKSUM"
puts compute_checksum(input)
puts compute_checksum(example)

def evenly_divisible(input)
  checksum = 0
  input.each do |row|
    numeric_row = row.split("\t").map { |x| x.to_i }.to_a

    numeric_row.combinations(2).each do |combo|
      min = combo.min
      max = combo.max
      if (max / min).to_f == (max.to_f / min.to_f)
        checksum += max / min
      end
    end
  end
  checksum
end

example2 = [
  "5\t9\t2\t8",
  "9\t4\t7\t3",
  "3\t8\t6\t5"
]
puts "EVENLY DIVISIBLE"
puts evenly_divisible(input)
puts evenly_divisible(example2)
