input = File.read("#{__DIR__}/../input/23.txt")
input_optimized = File.read("#{__DIR__}/../input/23_optimized.txt")

def get_value(registers, value)
  if /[0-9]+/ =~ value
    value.to_i64
  else
    register = value[0].to_s
    registers[register]
  end
end

def run_coprocessor(code)
  pc = 0
  registers = Hash(String, Int64).new(0_i64)
  instructions = code.split("\n")
  mul_count = 0

  while pc < instructions.size
    instruction = instructions[pc]
    parts = instruction.split(" ")
    # puts instruction
    case parts[0]
    when "set"
      registers[parts[1]] = get_value(registers, parts[2])
      pc += 1
    when "sub"
      registers[parts[1]] = registers[parts[1]] - get_value(registers, parts[2])
      pc += 1
    when "mul"
      registers[parts[1]] = registers[parts[1]] * get_value(registers, parts[2])
      mul_count += 1
      pc += 1
    when "jnz"
      if get_value(registers, parts[1]) != 0
        pc += get_value(registers, parts[2])
      else
        pc += 1
      end
    end
  end

  mul_count
end

puts run_coprocessor(input)

# Ended up using modified approach described here
# https://www.reddit.com/r/adventofcode/comments/7lrjei/2017_day_23_peephole_optimization_anyone/
def run_modified_coprocessor(code)
  pc = 0
  registers = Hash(String, Int64).new(0_i64)

  # Optimize instructions
  instructions = code.split("\n").map { |x| x.split(" ") }
  registers["a"] = 1_i64

  # Run optimized instructions
  while pc < instructions.size
    parts = instructions[pc]
    # puts parts
    case parts[0]
    when "set"
      registers[parts[1]] = get_value(registers, parts[2])
      pc += 1
    when "sub"
      registers[parts[1]] = registers[parts[1]] - get_value(registers, parts[2])
      pc += 1
    when "mod"
      registers[parts[1]] = registers[parts[1]] % get_value(registers, parts[2])
      pc += 1
    when "mul"
      registers[parts[1]] = registers[parts[1]] * get_value(registers, parts[2])
      pc += 1
    when "sqrt"
      registers[parts[1]] = Math.sqrt(get_value(registers, parts[2])).to_i64
      pc += 1
    when "jnz"
      if get_value(registers, parts[1]) != 0
        pc += get_value(registers, parts[2])
      else
        pc += 1
      end
    when "jgz"
      if get_value(registers, parts[1]) > 0
        pc += get_value(registers, parts[2])
      else
        pc += 1
      end
    when "nop"
      pc += 1
    end
  end

  registers["h"]
end

puts run_modified_coprocessor(input_optimized)
