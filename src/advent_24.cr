input = File.read("#{__DIR__}/../input/24.txt")

example = "0/2
2/2
2/3
3/4
3/5
0/1
10/1
9/10"

def permute_bridges(components_by_port, bridge = Array(Tuple(Int32, Int32)).new, bridge_value = 0)
  bridges = [] of Array(Tuple(Int32, Int32))

  # Start from base components
  if components_by_port[bridge_value]?
    components_by_port[bridge_value].each do |component|
      if !bridge.includes?(component)
        next_bridge = bridge + [component]
        bridges << next_bridge
        next_bridge_value = component[0] == bridge_value ? component[1] : component[0]
        bridges += permute_bridges(components_by_port, next_bridge, next_bridge_value)
      end
    end
  end

  bridges
end

def strongest_bridge(input)
  components_by_port = Hash(Int32, Array(Tuple(Int32, Int32))).new([] of Tuple(Int32, Int32))
  components = input.split("\n").map do |x|
    ports = x.split("/")
    comp = {ports[0].to_i, ports[1].to_i}
    components_by_port[comp[0]] += [comp]
    components_by_port[comp[1]] += [comp]
    comp
  end

  bridges = permute_bridges(components_by_port).uniq
  max = 0
  longest = bridges.map { |bridge| bridge.size }.max
  max_longest = 0

  bridges.each do |bridge|
    total = 0
    bridge.each do |component|
      total += component[0] + component[1]
    end

    if total > max
      max = total
    end

    if bridge.size == longest && total > max_longest
      max_longest = total
    end
  end

  {max, max_longest}
end

puts strongest_bridge(example)[0] # 31
puts strongest_bridge(input)      # ?
