# Coding Challenges

## First Coding Challenge

Write a Ruby method that accepts a string, reverses it, and returns the result. You can find an example method signature below:

```ruby
def my_reverse(string)
  # your code here
end

puts my_reverse('abc') # cba
```

### Constraints:
- You may use standard library methods such as `String#length`.
- Avoid using built-in reversing methods such as `String#reverse` or `String#reverse!`.

---

## Second Coding Challenge

Write a Ruby method to find the maximum value in a series of nested arrays. You can find the method signature and example below:

```ruby
def my_max(array)
  # your code here
end

puts my_max([1, [2, 3]]) # 3
```

### Constraints:
- The input will only contain integers and arrays (no strings, dates, etc.).
- You are limited to using only the `#length` and `#is_a?(Array)` methods from the standard library.
