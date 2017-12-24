input = File.read("#{__DIR__}/../input/09.txt")

def stream_processing(input)
  cursor = 0
  score = 0
  non_canceled = 0
  level = 1

  # Little nesting compiler
  while cursor < input.size
    char = input[cursor]
    case char
    when '{'
      score += level
      level += 1
      # puts "CURSOR #{cursor}"
      cursor += 1
    when '}'
      level -= 1
      cursor += 1
    when '<'
      cursor += 1
      # Skip garbage
      while input[cursor] != '>'
        # print "INPUT CURSOR #{input[cursor]}"
        # cursor += input[cursor] == '!' ? 2 : 1
        # puts " = #{cursor}"
        if input[cursor] == '!'
          cursor += 2
        else
          cursor += 1
          non_canceled += 1
        end

        non_canceled
      end
      cursor += 1
    when ','
      cursor += 1
    end
  end

  {score, non_canceled}
end

puts "GROUP SCORE"
puts stream_processing("{}")[0]                            # 1
puts stream_processing("{{{}}}")[0]                        # 6
puts stream_processing("{{},{}}")[0]                       # 5
puts stream_processing("{{{},{},{{}}}}")[0]                # 16
puts stream_processing("{<a>,<a>,<a>,<a>}")[0]             # 1
puts stream_processing("{{<ab>},{<ab>},{<ab>},{<ab>}}")[0] # 9
puts stream_processing("{{<!!>},{<!!>},{<!!>},{<!!>}}")[0] # 9
puts stream_processing("{{<a!>},{<a!>},{<a!>},{<ab>}}")[0] # 3
puts stream_processing(input)[0]                           # ?

puts "NON-CANCELED CHARACTERS"
puts stream_processing("<>")[1]                  # 0
puts stream_processing("<random characters>")[1] # 17
puts stream_processing("<<<<>")[1]               # 3
puts stream_processing("<{!>}>")[1]              # 2
puts stream_processing("<!!>")[1]                # 0
puts stream_processing("<!!!>>")[1]              # 0
puts stream_processing("<{o\"i!a,<{i<a>")[1]     # 10
puts stream_processing(input)[1]                 # ?
