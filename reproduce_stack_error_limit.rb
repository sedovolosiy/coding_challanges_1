#!/usr/bin/env ruby
# reproduce_stack_error_limit.rb

require 'benchmark'

# Рекурсивная версия my_max
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

# Генератор «глубокого» вложенного массива высоты depth (итерируемо)
def generate_deep(depth)
  arr = 0
  depth.times { arr = [arr] }
  arr
end

# Ищем глубину, при которой падаем
start_depth = 1_000
step        = 500
depth       = start_depth

loop do
  puts "Пробуем depth = #{depth}..."
  data = generate_deep(depth)
  begin
    my_max_recursive(data)
    puts "  OK на depth = #{depth}"
    depth += step
  rescue SystemStackError => e
    puts "  Пойман SystemStackError на depth = #{depth}"
    break
  end
end
