class Player
  ROBOT_NAMES = ['R2D2', 'Hal', 'Bernie Sanders'].freeze
  attr_accessor :marker, :name

  def initialize(marker)
    @marker = marker
    @name = ROBOT_NAMES.sample
  end

  def play(board)
    number = board.empty_square_numbers.sample
    board.place_marker(number, marker)
  end
end
