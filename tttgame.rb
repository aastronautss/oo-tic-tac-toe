require_relative 'board'
require_relative 'game_interface'
require_relative 'player'

class TTTGame
  attr_accessor :board, :players, :scores

  # ===----------------------=== #
  # Game loops
  # ===----------------------=== #

  def play
    display_welcome_message

    loop do
      play_match
      break unless play_again?
    end

    play_goodbye_message
  end

  def play_match
    loop do
      choose_turn_order
      play_round
      break if someone_won_match?
    end

    display_match_result
  end

  def play_round
    loop do
      display_board
      current_player_moves
      break if someone_won_round? || board_full?
      rotate_players!
    end

    update_scores
    display_round_result
  end
end

TTTGame.new.play
