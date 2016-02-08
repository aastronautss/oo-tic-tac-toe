def prompt(message)
  puts "=> #{message}"
end

def validate_input(valid_options)
  input = nil
  loop do
    input = gets.chomp.downcase
    break if valid_options.include? input
    prompt "Invalid input!"
  end
  input
end

def text_input(message)
  prompt message

  input = nil
  loop do
    input = gets.chomp
    break unless input.empty?
    prompt "You must enter something!"
  end
  input
end

def multiple_choice(message, options)
  display = "#{message} ( "
  options.each { |key, value| display << "#{value} (#{key}) " }
  display << "):"

  prompt display
  input = validate_input(options.keys)
  options[input]
end

def multiple_choice_without_list(message, options)
  prompt message
  validate_input(options)
end

def bool_input(message, yes = 'y', no = 'n')
  prompt "#{message} (#{yes}/#{no})"
  input = validate_input [yes, no]
  input == yes
end
