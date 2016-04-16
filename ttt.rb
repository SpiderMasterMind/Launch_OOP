class Board 
  attr_reader :squares
  WINNING_LINES = [[1, 2, 3], [4, 5, 6], [7, 8, 9]] +
                  [[1, 4, 7], [2, 5, 8], [3, 6, 9]] +
                  [[1, 5, 9], [3, 5, 7]]

  def initialize
    @squares = {}
    reset
  end

  def []=(num, marker)
    @squares[num].marker = marker
  end
  # rubocop:disable Metrics/AbcSize
  def draw
    puts ""
    puts "     |     |"
    puts "  #{@squares[1]}  |  #{@squares[2]}  |  #{@squares[3]}  "
    puts "     |     |"
    puts "-----+-----+-----"
    puts "     |     |"
    puts "  #{@squares[4]}  |  #{@squares[5]}  |  #{@squares[6]}  "
    puts "     |     |"
    puts "-----+-----+-----"
    puts "     |     |"
    puts "  #{@squares[7]}  |  #{@squares[8]}  |  #{@squares[9]}  "
    puts "     |     |"
    puts ""
  end
# rubocop:enable Metrics/AbcSize
  def unmarked_keys
    @squares.keys.select { |key| @squares[key].unmarked? }
  end

  def full?
    unmarked_keys.empty?
  end

  def someone_won?
    !!winning_marker
  end

  def winning_marker
    WINNING_LINES.each do |line|
      squares = @squares.values_at(*line)
      if three_identical_markers?(squares)
        return squares.first.marker
      end
    end
    nil
  end

  def reset
    (1..9).each { |key| @squares[key] = Square.new }
  end

  private

  def three_identical_markers?(squares)
    markers = squares.select(&:marked?).collect(&:marker)
    return false if markers.size != 3
    markers.min == markers.max
  end
end

class Square
  INITIAL_MARKER = " "
  attr_accessor :marker
  def initialize(marker = INITIAL_MARKER)
    @marker = marker
  end

  def to_s
    @marker
  end

  def marked?
    marker != INITIAL_MARKER
  end

  def human_marked?
    marker == HUMAN_MARKER
  end

  def unmarked?
    marker == INITIAL_MARKER
  end
end

class Player
  attr_reader :marker, :name
  def initialize(marker)
    @marker = marker
    @name = get_human_name
  end

  def get_human_name
    puts "Please enter your name:"
    answer = ""
    loop do
      answer = gets.chomp
      if answer.length > 0
        break
      else puts "Please enter a name"
      end
    end
    answer
  end
end

class Opponent
  attr_reader :marker, :name
  def initialize(marker)
    @marker = marker
    @name = find_computer_name
  end

  def find_computer_name
    %w(Kasparov ThufirHawat HAL).sample
  end
end

class TTTGame
  ROUNDS_TO_WIN = 5

  attr_reader :board, :human, :computer, :score

  def play
    display_welcome_message
    loop do
      clear_screen_and_display_board
      randomize_first_player
      loop do        
        current_player_moves
        break if board.someone_won? || board.full?
        clear_screen_and_display_board if human_turn?
      end
      show_and_process_result
      display_score
      display_match_winner
      break if someone_wins_match?
      break unless play_next_round?
      reset
      display_play_again_message
    end
    display_goodbye_message
  end

  private

  def initialize
    @board = Board.new
    @human = Player.new(set_marker)
    @computer = Opponent.new(other_marker)
    @score = [0, 0]
  end

  def display_welcome_message
    puts "Welcome to Tic Tac Toe!"
    puts ""
  end

  def randomize_first_player
    if board.unmarked_keys.count == 9
      @current_marker = [human.marker, computer.marker].sample
    end
  end

  def set_marker
    answer = ""
    puts "Choose your marker, O or X"
    loop do
      answer = gets.chomp.upcase
      break if %w(X O).include? answer
      puts "Please select an O or an X"
    end
    answer
  end

  def other_marker
    if human.marker == 'X'
      'O'
    else
      'X'
    end
  end

  def display_marker_choice
    puts "#{human.name}, you're an #{human.marker}, #{computer.name} is an #{computer.marker}"
  end

  def clear_screen_and_display_board
    clear_board
    board.draw
    display_marker_choice
  end

  def current_player_moves
    if human_turn?
      human_moves
      @current_marker = computer.marker
    else
      computer_moves
      @current_marker = human.marker
    end
  end

  def human_turn?
    @current_marker == human.marker
  end

  def joinor(arr, delimiter = ', ', word = 'or')
    arr[-1] = "#{word} #{arr.last}" if arr.size > 1
    arr.join(delimiter)
  end

  def human_moves
    puts "Choose a square (#{joinor(board.unmarked_keys)}): "
    square = nil
    loop do
      square = gets.chomp.to_i
      break if board.unmarked_keys.include?(square)
      puts "Sorry, not a valid choice"
    end
    board[square] = human.marker
  end

  def find_at_risk_square(line)
    arr = board.squares.values_at(*line).map do |obj|
      obj.marker
    end
    if arr.count(human.marker) == 2
      board.squares.select { |k, v| line.include?(k) && v.marker == " " }.keys.first
    else
      nil
    end
  end

  def find_winning_square(line)
    arr = board.squares.values_at(*line).map do |obj|
      obj.marker
    end
    if arr.count(computer.marker) == 2
      board.squares.select { |k, v| line.include?(k) && v.marker == " " }.keys.first
    else
      nil
    end
  end

  def computer_moves
    square = nil
    Board::WINNING_LINES.each do |line|
      square = find_winning_square(line)
      break if square
    end

    if !square
      Board::WINNING_LINES.each do |line|
        square = find_at_risk_square(line)
        break if square
      end
    end

    if board.unmarked_keys.include?(5)
      square = 5
    end

    if !square
      square = board.unmarked_keys.sample
    end
    board.squares[square].marker = computer.marker
  end

  def show_and_process_result
    board.draw

    case board.winning_marker
    when human.marker
      display_winner(human.name)
      score[0] += 1
    when computer.marker
      display_winner(computer.name)
      score[1] += 1
    else
      puts "The board is full!"
    end
  end
  
  def display_winner(name)
    puts "#{name} wins the round!"
  end

  def display_score
    puts "#{human.name}: #{score[0]}, #{computer.name}: #{score[1]}"
    puts "First to #{ROUNDS_TO_WIN}..WINS!"
  end

  def someone_wins_match?
    score[0] == ROUNDS_TO_WIN || score[1] == ROUNDS_TO_WIN
  end

  def display_match_winner
    if score[0] == ROUNDS_TO_WIN
      puts "You win the match!"
    elsif score[1] == ROUNDS_TO_WIN
      puts "You lose the match!"
    else puts "Next round commences"
    end
  end

  def display_goodbye_message
    puts "Goodbye!"
  end

  def clear_board
    system 'clear'
  end

  def play_next_round?
    answer = nil
    loop do
      puts "Play next round? (y/n)"
      answer = gets.chomp
      break if %w(y n).include? answer
      puts "Sorry, must be y or n"
    end

    answer == 'y'
  end

  def reset
    board.reset
    @current_marker = [human.marker, computer.marker].sample
    clear_board
  end

  def display_play_again_message
    puts "Lets play again!"
  end
end

game = TTTGame.new
game.play
