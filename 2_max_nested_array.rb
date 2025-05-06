#!/usr/bin/env ruby
# max_nested_array.rb

# Empirically determined on target hardware.
# Increase or decrease if you hit SystemStackError.
MAX_RECURSION_DEPTH = 8000

# Compute the maximum nesting depth of an array
def max_nesting_depth(nested_array)
  max_depth       = 1
  traversal_stack = [[nested_array, 1]]

  until traversal_stack.empty?
    current_array, depth = traversal_stack.pop
    max_depth = depth if depth > max_depth

    index = 0
    while index < current_array.length
      element = current_array[index]
      if element.is_a?(Array)
        traversal_stack << [element, depth + 1]
      end
      index += 1
    end
  end

  max_depth
end

# Recursive approach: minimal allocations
def max_in_nested_array_recursive(nested_array)
  current_max = nil
  index       = 0

  while index < nested_array.length
    element     = nested_array[index]
    element_max = element.is_a?(Array) ?
                    max_in_nested_array_recursive(element) :
                    element

    if current_max.nil? || element_max > current_max
      current_max = element_max
    end

    index += 1
  end

  current_max
end

# Iterative approach: explicit stack, safe for very deep structures
def max_in_nested_array_iterative(nested_array)
  traversal_stack = [[nested_array, 0]]
  current_max     = nil

  until traversal_stack.empty?
    current_array, position = traversal_stack.last

    if position < current_array.length
      element = current_array[position]
      traversal_stack.last[1] += 1

      if element.is_a?(Array)
        traversal_stack << [element, 0]
      else
        if current_max.nil? || element > current_max
          current_max = element
        end
      end
    else
      traversal_stack.pop
    end
  end

  current_max
end

# Public API: choose strategy by nesting depth
def max_in_nested_array(nested_array)
  depth = max_nesting_depth(nested_array)
  if depth < MAX_RECURSION_DEPTH
    max_in_nested_array_recursive(nested_array)
  else
    max_in_nested_array_iterative(nested_array)
  end
end

# Example:
# puts max_in_nested_array([1, [2, 3]])        # => 3
# puts max_in_nested_array([5, [1, [7, 2], 4]]) # => 7
if __FILE__ == $0
  puts max_in_nested_array([1, [2, 3]])                   # => 3
  puts max_in_nested_array([5, [1, [7, 2], 4], 6, [0]])   # => 7
  puts max_in_nested_array([[[[42]]]])                   # => 42

  # Very deep structure → iterative
  deep_nested = 8500.times.reduce(0) { |acc, _| [acc] }
  puts max_in_nested_array(deep_nested)                  # => 0
end
