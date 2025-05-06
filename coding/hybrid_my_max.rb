#!/usr/bin/env ruby
# hybrid_my_max.rb

# Depth threshold for using recursion
RECURSION_DEPTH_THRESHOLD = 8000

# Recursive version of finding the maximum value
def my_max_recursive(array)
  max_val = nil
  i = 0
  while i < array.length
    el = array[i]
    candidate = el.is_a?(Array) ? my_max_recursive(el) : el
    max_val = candidate if max_val.nil? || candidate > max_val
    i += 1
  end
  max_val
end

# Iterative version of finding the maximum value (with explicit stack)
def my_max_iterative(array)
  stack   = [[array, 0]]
  max_val = nil

  until stack.empty?
    current, idx = stack.last

    if idx < current.length
      el = current[idx]
      stack.last[1] += 1

      if el.is_a?(Array)
        stack << [el, 0]
      else
        max_val = el if max_val.nil? || el > max_val
      end
    else
      stack.pop
    end
  end

  max_val
end

# Iterative depth detection
# Returns the maximum depth (1 for flat array)
def detect_depth(array)
  max_depth = 1
  stack = [[array, 1]]

  until stack.empty?
    current, depth = stack.pop
    max_depth = depth if depth > max_depth

    i = 0
    while i < current.length
      el = current[i]
      if el.is_a?(Array)
        stack << [el, depth + 1]
      end
      i += 1
    end
  end

  max_depth
end

# Hybrid wrapper
# If nesting is less than threshold - use recursion, otherwise - use iteration
def my_max(array)
  depth = detect_depth(array)
  if depth < RECURSION_DEPTH_THRESHOLD
    my_max_recursive(array)
  else
    my_max_iterative(array)
  end
end

# Usage example
sample_flat    = [5, [1, [7, 2], 4], 6, [0, [9]]]
sample_deep    = [ [ [ [42] ] ] ]
sample_hybrid1 = Array.new(3) { Array.new(3) { rand(0..100) } }
# generate a deeply nested array in one column
sample_hybrid2 = (RECURSION_DEPTH_THRESHOLD + 10).times.reduce(0) { |acc, _| [acc] }

puts "Maximum of sample_flat:    #{my_max(sample_flat)}"    # → 9
puts "Maximum of sample_deep:    #{my_max(sample_deep)}"    # → 42
puts "Maximum of sample_hybrid1: #{my_max(sample_hybrid1)}" # normal depth → recursion
puts "Maximum of sample_hybrid2: #{my_max(sample_hybrid2)}" # depth > threshold → iteration
