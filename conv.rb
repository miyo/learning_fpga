contents = $stdin.read()
#contents = "aaa\\verb|bb|\\verb|cc|ddd"
contents = contents.gsub(/\\verb\|([^\|]*)\|/){|x| " `#{$1}` "}
puts contents
