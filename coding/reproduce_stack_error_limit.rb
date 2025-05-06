#!/usr/bin/env ruby
# reproduce_stack_error_limit.rb

require 'benchmark'

# Recursive version of my_max
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

# Generator of "deep" nested array with height = depth (iteratively)
def generate_deep(depth)
  arr = 0
  depth.times { arr = [arr] }
  arr
end

# Find the depth at which we get a stack overflow
start_depth = 1_000
step        = 500
depth       = start_depth

loop do
  puts "Trying depth = #{depth}..."
  data = generate_deep(depth)
  begin
    my_max_recursive(data)
    puts "  OK at depth = #{depth}"
    depth += step
  rescue SystemStackError
    puts "  Caught SystemStackError at depth = #{depth}"
    break
  end
end
