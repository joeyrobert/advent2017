input = File.read_lines("#{__DIR__}/../input/08.txt")

example = "b inc 5 if a > 1
a inc 1 if b < 5
c dec -10 if a >= 1
c inc -20 if c == 10".split("\n")

def parse_instructions(instructions)
  registers = {} of String => Int32
  pc = 0
  max = 0

  instructions.each do |instruction|
    components = instruction.split(" ")
    register, operation, amount, if_, condition_register, condition, condition_value = components
    condition_value = condition_value.to_i
    amount = amount.to_i
    condition_register_value = registers[condition_register]? || 0

    # puts "Condition register value #{condition_register_value}"

    condition_result = case condition
                       when ">"
                         condition_register_value > condition_value
                       when ">="
                         condition_register_value >= condition_value
                       when "<"
                         condition_register_value < condition_value
                       when "<="
                         condition_register_value <= condition_value
                       when "=="
                         condition_register_value == condition_value
                       when "!="
                         condition_register_value != condition_value
                       else
                         raise Exception.new("Invalid condition: #{condition}")
                       end

    if condition_result
      registers[register] = (registers[register]? || 0) + case operation
      when "inc"
        amount
      when "dec"
        -1 * amount
      else
        raise Exception.new("Invalid operation: #{operation}")
      end
    else
      registers[register] = (registers[register]? || 0)
    end

    max = Math.max(max, registers[register])

    # puts "#{register} = #{registers[register]}"
  end

  # puts registers
  {registers.values.max, max}
end

puts "EXAMPLE"
puts parse_instructions(example)
puts "INPUT"
puts parse_instructions(input)
