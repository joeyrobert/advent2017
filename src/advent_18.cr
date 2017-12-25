example = "set a 1
add a 2
mul a a
mod a 5
snd a
set a 0
rcv a
jgz a -1
set a 1
jgz a -2"

input = File.read("#{__DIR__}/../input/18.txt")

def get_value(registers, value)
  if /[0-9]+/ =~ value
    value.to_i64
  else
    register = value[0].to_s
    registers[register]
  end
end

def run_sound_assembly(code)
  pc = 0
  registers = Hash(String, Int64).new(0_i64)
  instructions = code.split("\n")
  last_sound = Int32::MAX

  loop do
    instruction = instructions[pc]
    parts = instruction.split(" ")
    case parts[0]
    when "snd"
      last_sound = get_value(registers, parts[1])
      pc += 1
    when "set"
      registers[parts[1]] = get_value(registers, parts[2])
      pc += 1
    when "add"
      registers[parts[1]] = registers[parts[1]] + get_value(registers, parts[2])
      pc += 1
    when "mul"
      registers[parts[1]] = registers[parts[1]] * get_value(registers, parts[2])
      pc += 1
    when "mod"
      registers[parts[1]] = registers[parts[1]] % get_value(registers, parts[2])
      pc += 1
    when "rcv"
      if get_value(registers, parts[1]) > 0
        return last_sound
      end
      pc += 1
    when "jgz"
      if get_value(registers, parts[1]) > 0
        pc += get_value(registers, parts[2])
      else
        pc += 1
      end
    end
  end
end

puts "SOUND"
puts run_sound_assembly(example) # 4
puts run_sound_assembly(input)   # ?


def run_parallel_assembly(code)
  instructions = code.split("\n").map { |x| x.split(" ") }

  receivers = [
    [] of Int64,
    [] of Int64,
  ]
  pc = [0, 0]
  registers = [
    Hash(String, Int64).new(0_i64),
    Hash(String, Int64).new(0_i64),
  ]
  program = 0
  waiting = [false, false]
  terminated = [false, false]
  send_count = [0, 0]

  registers[0]["p"] = 0_i64
  registers[1]["p"] = 1_i64

  loop do
    # if waiting[0] && waiting[1]
    #   puts "DEADLOCK"
    # end

    if (waiting[0] && waiting[1]) || (waiting[0] && terminated[1]) || (waiting[1] && terminated[0]) || (terminated[0] && terminated[1])
      break
    end

    if terminated[program]
      program ^= 1
      next
    end

    if pc[program] < 0 || pc[program] >= instructions.size
      terminated[program] = true
      next
    end

    parts = instructions[pc[program]]

    # puts parts

    case parts[0]
    when "snd"
      # Send a message to the other program
      send_count[program] += 1
      receivers[program ^ 1] << get_value(registers[program], parts[1])
      # puts receivers
      pc[program] += 1
    when "set"
      registers[program][parts[1]] = get_value(registers[program], parts[2])
      pc[program] += 1
    when "add"
      registers[program][parts[1]] = registers[program][parts[1]] + get_value(registers[program], parts[2])
      pc[program] += 1
    when "mul"
      registers[program][parts[1]] = registers[program][parts[1]] * get_value(registers[program], parts[2])
      pc[program] += 1
    when "mod"
      registers[program][parts[1]] = registers[program][parts[1]] % get_value(registers[program], parts[2])
      pc[program] += 1
    when "rcv"
      begin
        received = receivers[program].shift
        registers[program][parts[1]] = received
        pc[program] += 1
        if waiting[program]
          waiting[program] = false
          # puts "unwaiting #{program}"
        end
      rescue
        # Don't increment program counter
        waiting[program] = true
      # puts "waiting #{program}"
      end
    when "jgz"
      if get_value(registers[program], parts[1]) > 0
        pc[program] += get_value(registers[program], parts[2])
      else
        pc[program] += 1
      end
    end

    program ^= 1
  end

  send_count[1]
end

puts "PARALLEL"
puts run_parallel_assembly("snd 1
snd 2
snd p
rcv a
rcv b
rcv c
rcv d")
puts run_parallel_assembly(input)
