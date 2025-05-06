def my_reverse(string)
  output = ""
  index = string.length - 1
  while index >= 0
    output << string[index]
    index -= 1
  end
  output
end
