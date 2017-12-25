example = "p=< 3,0,0>, v=< 2,0,0>, a=<-1,0,0>
p=< 4,0,0>, v=< 0,0,0>, a=<-2,0,0>"

input = File.read("#{__DIR__}/../input/20.txt")

def add_3d(a, b)
  [a[0] + b[0], a[1] + b[1], a[2] + b[2]]
end

def distance(a, b)
  (a[0] - b[0]).abs + (a[1] - b[1]).abs + (a[2] - b[2]).abs
end

def euler(input, iterations = 1000)
  p = [] of Array(Int32)
  v = [] of Array(Int32)
  a = [] of Array(Int32)

  particles = input.split("\n").map do |line|
    parts = line.split(", ")
    p << parts[0][3...-1].split(",").map { |x| x.to_i }
    v << parts[1][3...-1].split(",").map { |x| x.to_i }
    a << parts[2][3...-1].split(",").map { |x| x.to_i }
  end

  iterations.times do
    # velocity
    a.each_with_index do |a_delta, i|
      v[i] = add_3d(v[i], a_delta)
    end

    # position
    v.each_with_index do |v_delta, i|
      p[i] = add_3d(p[i], v_delta)
    end
  end

  min_d = Int32::MAX
  min_p = 0

  p.each_with_index do |pos, i|
    d = distance(pos, [0, 0, 0])
    # puts d
    if d < min_d
      min_p = i
      min_d = d
    end
  end

  min_p
end

puts "MIN DISTANCE"
puts euler(example)
puts euler(input)

def euler_remove_collisions(input, iterations = 1000)
  p = [] of Array(Int32)
  v = [] of Array(Int32)
  a = [] of Array(Int32)

  particles = input.split("\n").map do |line|
    parts = line.split(", ")
    p << parts[0][3...-1].split(",").map { |x| x.to_i }
    v << parts[1][3...-1].split(",").map { |x| x.to_i }
    a << parts[2][3...-1].split(",").map { |x| x.to_i }
  end

  iterations.times do
    # velocity
    a.each_with_index do |a_delta, i|
      v[i] = add_3d(v[i], a_delta)
    end

    # position
    v.each_with_index do |v_delta, i|
      p[i] = add_3d(p[i], v_delta)
    end

    # remove collisions
    index_by_pos = {} of Array(Int32) => Array(Int32)

    p.each_with_index do |pos, i|
      index_by_pos[pos] ||= [] of Int32
      index_by_pos[pos] << i
    end

    to_remove = [] of Int32
    index_by_pos.each do |pos, indexes|
      if indexes.size > 1
        to_remove += indexes
      end
    end

    to_remove.sort.reverse.each do |i|
      p.delete_at(i)
      v.delete_at(i)
      a.delete_at(i)
    end
  end

  p.size
end

example2 = "p=<-6,0,0>, v=< 3,0,0>, a=< 0,0,0>
p=<-4,0,0>, v=< 2,0,0>, a=< 0,0,0>
p=<-2,0,0>, v=< 1,0,0>, a=< 0,0,0>
p=< 3,0,0>, v=<-1,0,0>, a=< 0,0,0>"

puts "REMOVE COLLISIONS"
puts euler_remove_collisions(example2)
puts euler_remove_collisions(input)
