class Generator
  def initialize(@factor : Int64, @value : Int64)
  end

  def next
    @value = (@value * @factor) % 2147483647_i64
    @value
  end
end

def judge(gen_a, gen_b)
  lower_bits = 2 ** 16 - 1
  count = 0

  40_000_000.times do
    a = gen_a.next
    b = gen_b.next

    if a & lower_bits == b & lower_bits
      count += 1
    end
  end
  count
end

# x = Generator.new(16807_i64, 65_i64)
# puts x.next
# puts x.next
# puts x.next
# puts x.next
# puts x.next

puts "JUDGE"
puts judge(
  Generator.new(16807_i64, 65_i64),
  Generator.new(48271_i64, 8921_i64)
)
puts judge(
  Generator.new(16807_i64, 873_i64),
  Generator.new(48271_i64, 583_i64)
)

class MultipleGenerator
  def initialize(@factor : Int64, @value : Int64, @multiple : Int64)
  end

  def next
    possible = (@value * @factor) % 2147483647_i64

    while (possible / @multiple).to_f != (possible.to_f / @multiple.to_f)
      possible = (possible * @factor) % 2147483647_i64
    end

    @value = possible
    @value
  end
end

def judge_multiple(gen_a, gen_b)
  lower_bits = 2 ** 16 - 1
  count = 0

  5_000_000.times do
    a = gen_a.next
    b = gen_b.next

    if a & lower_bits == b & lower_bits
      count += 1
    end
  end
  count
end

# x = MultipleGenerator.new(48271_i64, 8921_i64, 8_i64)
# puts x.next
# puts x.next
# puts x.next
# puts x.next
# puts x.next

puts "JUDGE MULTIPLE"
puts judge_multiple(
  MultipleGenerator.new(16807_i64, 65_i64, 4_i64),
  MultipleGenerator.new(48271_i64, 8921_i64, 8_i64)
)
puts judge_multiple(
  MultipleGenerator.new(16807_i64, 873_i64, 4_i64),
  MultipleGenerator.new(48271_i64, 583_i64, 8_i64)
)
