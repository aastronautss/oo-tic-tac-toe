require_relative 'board'
require_relative 'computer'
require_relative 'game_interface'
require_relative 'human'

# A game of tic-tac-toe.
class TTTGame
  NUM_PLAYERS = 2
  BOARD_SIZE = 3
  MAX_WINS = 3
  MARKERS = ['O', 'X'].freeze

  attr_accessor :board, :players, :scores

  def initialize
    @players = []
    @scores = {}
  end

  # ===----------------------=== #
  # Game loops
  # ===----------------------=== #

  # Main game loop. Wraps around the match (and by proxy, the round)
  def play
    display_welcome_message
    init_players

    loop do
      play_match
      break unless play_again?
    end

    display_goodbye_message
  end

  private

  # The match loop. Tallys the score, and declares a winner. Wraps around the
  # round loop.
  def play_match
    reset_scores

    loop do
      display_scores
      choose_turn_order
      play_round
      break if someone_won_match?
    end

    display_match_result
  end

  # The round loop. Knows whose turn it is and will stop the game in the case
  # of a victory or a tie.
  def play_round
    reset_board

    loop do
      display_board
      current_player_moves
      break if someone_won_round? || board_full?
      rotate_players!
    end

    the_winner = winner
    display_board
    display_round_result(the_winner)
    update_scores!(the_winner)
  end

  # ===----------------------=== #
  # Display methods
  # ===----------------------=== #

  def display_welcome_message
    prompt "Welcome to Tic Tac Toe!"
  end

  def display_goodbye_message
    prompt "Thanks for playing Tic Tac Toe. Goodbye!"
  end

  def display_board
    puts board
  end

  def display_round_result(winner)
    if winner
      prompt "#{winner.name.capitalize} wins this round!"
    else
      prompt "It's a tie!"
    end
  end

  def display_scores
    scores.each do |player, score|
      prompt "#{player.name.capitalize}: #{score}"
    end
  end

  def display_match_result
    display_scores
    prompt "#{match_winner.name} wins the match!"
  end

  # ===----------------------=== #
  # Game setup
  # ===----------------------=== #

  # Asks what kind of player each player is, and creates a new player of that
  # type, assigning them a marker. Adds that player to the list of players.
  def init_players
    markers = MARKERS.dup
    (1..NUM_PLAYERS).each do |player_num|
      player_type = multiple_choice("Choose player #{player_num} type",
                                    'h' => Human, 'c' => Computer)
      @players << player_type.new(markers.pop)
    end
  end

  def reset_scores
    players.each { |player| @scores[player] = 0 }
  end

  # Resets the board.
  def reset_board
    @board = Board.new(BOARD_SIZE)
  end

  # Shuffles the player queue.
  def choose_turn_order
    @players.shuffle!
  end

  # ===----------------------=== #
  # Game execution
  # ===----------------------=== #

  def current_player_moves
    current_player.play(board)
  end

  def rotate_players!
    players.rotate!
  end

  def current_player
    players.first
  end

  # ===----------------------=== #
  # Game results
  # ===----------------------=== #

  def someone_won_round?
    !!winner
  end

  def board_full?
    @board.full?
  end

  def winner
    the_winning_line = winning_line
    return nil unless the_winning_line
    marker = the_winning_line.first.marker
    get_player_by_marker(marker)
  end

  def winning_line
    lines = @board.all_lines
    lines.find { |line| line_has_winner? line }
  end

  def line_has_winner?(line)
    player_markers.each do |marker|
      return true if line.all? { |space| space.marker == marker }
    end
    false
  end

  def update_scores!(winner)
    @scores[winner] += 1 if winner
  end

  def match_winner
    @scores.each { |player, score| return player if score >= MAX_WINS }
    nil
  end

  def someone_won_match?
    @scores.values.any? { |score| score >= MAX_WINS }
  end

  # ===----------------------=== #
  # User input
  # ===----------------------=== #

  def play_again?
    bool_input "Play again?"
  end

  # ===----------------------=== #
  # General info
  # ===----------------------=== #

  def get_player_by_marker(marker)
    @players.find { |player| player.marker == marker }
  end

  def player_markers
    @players.map(&:marker)
  end
end

TTTGame.new.play
