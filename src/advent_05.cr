input = File.read_lines("#{__DIR__}/../input/05.txt").map { |x| x.to_i }

def run_jump_instructions(inst)
  count = 0
  curr = 0
  inc_by_inst = {} of Int32 => Int32

  while curr >= 0 && curr < inst.size
    offset = (inc_by_inst[curr]? || 0) + inst[curr]
    # print "#{curr} + #{offset} "
    inc_by_inst[curr] = (inc_by_inst[curr]? || 0) + 1
    curr += offset
    # puts "= #{curr}"
    count += 1
  end
  count
end

example = [0, 3, 0, 1, -3]
puts run_jump_instructions(example)
puts run_jump_instructions(input)

def run_jump_instructions_conditions(inst)
  count = 0
  curr = 0
  inc_by_inst = {} of Int32 => Int32

  while curr >= 0 && curr < inst.size
    offset = (inc_by_inst[curr]? || 0) + inst[curr]
    # print "#{curr} + #{offset} "
    delta = ((inc_by_inst[curr]? || 0) + inst[curr]) >= 3 ? -1 : 1
    # puts "delta #{delta}"
    inc_by_inst[curr] = (inc_by_inst[curr]? || 0) + delta
    curr += offset
    # puts "= #{curr}"
    count += 1
  end
  count
end

puts run_jump_instructions_conditions(example)
puts run_jump_instructions_conditions(input)
