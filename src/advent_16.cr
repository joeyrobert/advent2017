input = File.read("#{__DIR__}/../input/16.txt").split(',')

def dance(initial, instructions)
  programs = initial.chars

  instructions.each do |instruction|
    case instruction[0]
    when 's'
      number = -1 * instruction[1..-1].to_i
      programs = programs[number..-1] + programs[0...number]
    when 'x'
      a_pos, b_pos = instruction[1..-1].split('/').map { |x| x.to_i }
      temp = programs[a_pos]
      programs[a_pos] = programs[b_pos]
      programs[b_pos] = temp
    when 'p'
      a, b = instruction[1..-1].split('/').map { |x| x[0] }
      a_pos = programs.index { |x| x == a }
      b_pos = programs.index { |x| x == b }

      if a_pos.nil? || b_pos.nil?
        raise Exception.new("Can't find value")
      end

      temp = programs[a_pos]
      programs[a_pos] = programs[b_pos]
      programs[b_pos] = temp
    end
  end

  programs.join
end

puts dance("abcde", ["s1", "x3/4", "pe/b"])
puts dance("abcdefghijklmnop", input)

def dance_alot(initial, instructions)
  programs = initial
  encountered = {} of String => Bool
  cycle = [] of String
  count = 1_000_000_000

  while encountered[programs]?.nil?
    cycle << programs
    encountered[programs] = true
    programs = dance(programs, instructions)
  end

  cycle[1_000_000_000 % cycle.size]
end

puts dance_alot("abcdefghijklmnop", input)
