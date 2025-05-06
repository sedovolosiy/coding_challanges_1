#!/usr/bin/env ruby
# hybrid_my_max.rb

# Порог глубины для использования рекурсии
RECURSION_DEPTH_THRESHOLD = 8000

# Рекурсивная версия поиска максимума
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

# Итеративная версия поиска максимума (с явным стеком)
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

# Итеративная проверка глубины вложенности
# Возвращает максимальную глубину (1 для плоского массива)
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

# Гибридная обёртка
# Если вложенность меньше порога — рекурсия, иначе — итерация
def my_max(array)
  depth = detect_depth(array)
  if depth < RECURSION_DEPTH_THRESHOLD
    my_max_recursive(array)
  else
    my_max_iterative(array)
  end
end

# Пример использования
sample_flat    = [5, [1, [7, 2], 4], 6, [0, [9]]]
sample_deep    = [ [ [ [42] ] ] ]
sample_hybrid1 = Array.new(3) { Array.new(3) { rand(0..100) } }
# генерируем сильно вложенный массив в один столбец
sample_hybrid2 = (RECURSION_DEPTH_THRESHOLD + 10).times.reduce(0) { |acc, _| [acc] }

puts "Максимум sample_flat:    #{my_max(sample_flat)}"    # → 9
puts "Максимум sample_deep:    #{my_max(sample_deep)}"    # → 42
puts "Максимум sample_hybrid1: #{my_max(sample_hybrid1)}" # обычная глубина → рекурсия
puts "Максимум sample_hybrid2: #{my_max(sample_hybrid2)}" # глубина > порога → итерация
