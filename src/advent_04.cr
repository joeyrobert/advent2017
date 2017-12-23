input = File.read_lines("#{__DIR__}/../input/04.txt")

def valid_passwords(input)
  valid_pass = 0
  input.each do |password|
    passes = password.split(' ')
    if passes.size == passes.uniq.size
      valid_pass += 1
    end
  end
  valid_pass
end

puts valid_passwords(input)

def valid_passwords_anagram(input)
  valid_pass = 0
  input.each do |password|
    passes = password.split(' ').map {|x| x.chars.sort.join() }
    if passes.size == passes.uniq.size
      passes.each
      valid_pass += 1
    end
  end
  valid_pass
end

puts valid_passwords_anagram(input)
