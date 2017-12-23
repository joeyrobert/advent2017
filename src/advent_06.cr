input = File.read("#{__DIR__}/../input/06.txt").split("\t").map{ |x| x.to_i }

def reconfigure(memory : Array(Int32))
  max = memory.max
  max_index = memory.index{|x| x == max}
  # puts "max #{max} max index #{max_index}"
  if !max_index.nil?
    cache = memory[max_index]
    memory[max_index] = 0
    index = (max_index + 1) % memory.size
    while cache > 0
      memory[index] += 1
      index = (index + 1) % memory.size
      cache -= 1
    end
  end
  memory
end

def count_reconfigures(memory : Array(Int32))
  count = 0
  seen_before = {} of String => Bool

  while !seen_before[memory.to_s]?
    seen_before[memory.to_s] = true
    memory = reconfigure(memory)
    count += 1
  end
  # puts seen_before
  count
end

example = [0, 2, 7, 0]
puts "MEMORY"
puts count_reconfigures(example)
puts count_reconfigures(input)

def count_cycles(memory : Array(Int32))
  base_memory = memory.to_s
  count = 0

  while count == 0 || memory.to_s != base_memory
    memory = reconfigure(memory)
    count += 1
  end
  count
end

def count_reconfigures_cycles(memory : Array(Int32))
  seen_before = {} of String => Bool

  while !seen_before[memory.to_s]?
    seen_before[memory.to_s] = true
    memory = reconfigure(memory)
  end

  cycles = count_cycles(memory)
  cycles
end

puts "CYCLES"
example = [0, 2, 7, 0]
puts count_reconfigures_cycles(example)
puts count_reconfigures_cycles(input)
