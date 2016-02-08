require_relative 'game_interface'
require_relative 'player'

class Human < Player
  def initialize(marker)
    super
    @name = text_input 'Please enter your name:'
  end

  def play(board)
    square_number = nil
    loop do
      input = multiple_choice_without_list("Choose a space:", board.options)
      square_number = input.to_i
      break if board.space_empty? square_number
      prompt "Space taken!"
    end

    board.place_marker(square_number, @marker)
  end
end
