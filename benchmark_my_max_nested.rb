#!/usr/bin/env ruby
# benchmark_my_max_nested.rb

require 'benchmark'

# Рекурсивная версия
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

# Итеративная версия (с собственным стеком)
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

# Генератор «полного» вложенного дерева: width^depth чисел
def generate_nested(depth, width)
  return rand(0..1_000_000) if depth.zero?
  Array.new(width) { generate_nested(depth - 1, width) }
end

# Параметры теста
DEPTH = 6   # глубина рекурсии
WIDTH = 5   # ширина на каждом уровне
data = generate_nested(DEPTH, WIDTH)

# Прогрев
3.times do
  my_max_recursive(data)
  my_max_iterative(data)
end

runs = 10
total_leaves = WIDTH**DEPTH
puts "Benchmarking nested array depth=#{DEPTH}, width=#{WIDTH} (~#{total_leaves} numbers), #{runs} runs each\n\n"

# Измеряем рекурсивную версию
recursive_bm = Benchmark.measure do
  runs.times { my_max_recursive(data) }
end
puts "Recursive: #{recursive_bm.real.round(4)}s"

# Измеряем итеративную версию
iterative_bm = Benchmark.measure do
  runs.times { my_max_iterative(data) }
end
puts "Iterative: #{iterative_bm.real.round(4)}s"
