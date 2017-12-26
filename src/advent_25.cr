input = File.read("#{__DIR__}/../input/25.txt")

example = "Begin in state A.
Perform a diagnostic checksum after 6 steps.

In state A:
  If the current value is 0:
    - Write the value 1.
    - Move one slot to the right.
    - Continue with state B.
  If the current value is 1:
    - Write the value 0.
    - Move one slot to the left.
    - Continue with state B.

In state B:
  If the current value is 0:
    - Write the value 1.
    - Move one slot to the left.
    - Continue with state A.
  If the current value is 1:
    - Write the value 1.
    - Move one slot to the right.
    - Continue with state A."

def turing(input)
  lines = input.split("\n")
  state = lines[0].split("state ")[1][0..-2]
  steps = lines[1].split(" ")[5].to_i
  current_state = "A"
  current_value = 0
  instructions = {} of String => Array(Array(Array(String)))
  next_instructions = [] of Array(String)

  lines[2..-1].each do |line|
    if /^In state [A-Z]:$/ =~ line
      current_state = line.split(' ')[2][0..-2]
      # puts "SETTING #{current_state}"
    elsif /^  If the current value is [0-1]:$/ =~ line
      current_value = line.split(' ')[7][0..-2].to_i
    elsif /^    - Write the value [0-1]\.$/ =~ line
      # puts "WRITE"
      next_instructions << ["write", line.split(' ')[8][0..-2]]
      # puts line.split(' ')[8][0..-2].to_i
    elsif /^    - Move one slot to the (right|left)\.$/ =~ line
      # puts "MOVE"
      next_instructions << ["move", line.split(' ')[10][0..-2]]
      # puts line.split(' ')[10][0..-2]
    elsif /^    - Continue with state [A-Z]\.$/ =~ line
      # puts "CONTINUE"
      next_instructions << ["continue", line.split(' ')[8][0..-2]]
      instructions[current_state] ||= [[] of Array(String), [] of Array(String)]
      instructions[current_state][current_value] = next_instructions
      next_instructions = [] of Array(String)
      # puts line.split(' ')[8][0..-2]
    end
  end

  tape = Hash(Int32, Int32).new(0)
  cursor = 0

  steps.times do
    s = instructions[state][tape[cursor]]
    s.each do |i|
      case i[0]
      when "write"
        tape[cursor] = i[1].to_i
      when "move"
        cursor += i[1] == "right" ? 1 : -1
      when "continue"
        state = i[1]
      end
    end
  end

  checksum = 0

  tape.each_value do |v|
    checksum += v
  end

  checksum
end

puts turing(example)
puts turing(input)
