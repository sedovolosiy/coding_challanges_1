#!/usr/bin/env ruby
# benchmark_my_max.rb

require 'benchmark'

# Recursive version
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

# Iterative version (with explicit stack)
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

# Generate large flat array
DATA_SIZE = 2_000_000
data = Array.new(DATA_SIZE) { rand(0..1_000_000) }

# Warm-up to exclude overhead of first run
3.times do
  my_max_recursive(data)
  my_max_iterative(data)
end

runs = 10
puts "Benchmarking on flat array of #{DATA_SIZE} elements (#{runs} runs each)\n\n"

# Measure recursive version
recursive_bm = Benchmark.measure do
  runs.times { my_max_recursive(data) }
end
puts "Recursive: #{recursive_bm.real.round(4)}s"

# Measure iterative version
iterative_bm = Benchmark.measure do
  runs.times { my_max_iterative(data) }
end
puts "Iterative: #{iterative_bm.real.round(4)}s"
