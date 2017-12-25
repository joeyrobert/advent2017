class Node
  property value
  property right
  @right : Node | Nil

  def initialize(@value : Int32, @right : Node | Nil = nil)
  end

  def next
    @right || self
  end
end

def spinlock(offset, max = 2017, target = 2017)
  buffer = [0]
  value = 1
  curr = 0

  while value <= max
    curr = (curr + offset) % buffer.size
    buffer.insert(curr + 1, value)
    curr += 1
    value += 1
  end

  pos = buffer.index { |x| x == target } || 0
  buffer[(pos + 1) % buffer.size]
end

def spinlock_linked(offset, max = 2017, target = 2017)
  buffer = Node.new(0)
  value = 1

  while value <= max
    # if value % 100000 == 0
    #   puts value
    # end
    offset.times do
      buffer = buffer.next
    end

    buffer.right = Node.new(value, buffer.next)
    buffer = buffer.next
    value += 1
  end

  loop do
    if buffer.value == target
      return buffer.next.value
    end

    buffer = buffer.next
  end
end

puts spinlock(3)
puts spinlock(371)

puts spinlock_linked(3)
puts spinlock_linked(371)
puts spinlock_linked(371, 50000000, 0)
