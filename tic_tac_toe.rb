require 'pry'

MAX_ROUNDS      = 5
INITIAL_MARKER  = ' '
PLAYER_MARKER   = 'X'
COMPUTER_MARKER = 'O'
WINNING_LINES   = [[1, 2, 3], [4, 5, 6], [7, 8, 9], [1, 4, 7], [2, 5, 8],
                   [3, 6, 9], [1, 5, 9], [7, 5, 3]]

# rubocop:disable Metrics/MethodLength, Metrics/AbcSize
def display_board(board)
  system 'clear'
  puts "Player is a [#{PLAYER_MARKER}] Computer is a [#{COMPUTER_MARKER}]"
  puts ""
  puts "     |     |     "
  puts "  #{board[1]}  |  #{board[2]}  |  #{board[3]}  "
  puts "     |     |     "
  puts "-----------------"
  puts "     |     |     "
  puts "  #{board[4]}  |  #{board[5]}  |  #{board[6]}  "
  puts "     |     |     "
  puts "-----------------"
  puts "     |     |     "
  puts "  #{board[7]}  |  #{board[8]}  |  #{board[9]}  "
  puts "     |     |     "
  puts ""
end
# rubocop:enable Metrics/MethodLength, Metrics/AbcSize

def initialize_board
  new_board = {}
  (1..9).each { |num| new_board[num] = INITIAL_MARKER }
  new_board
end

def empty_squares(board)
  board.keys.select { |num| board[num] == INITIAL_MARKER }
end

def player_turn(board)
  square = ''
  loop do
    puts "Choose a square #{joinor(empty_squares(board))}"
    square = gets.chomp.to_i
    break if empty_squares(board).include?(square)
    puts "Sorry this is not a valid square."
  end
  board[square] = PLAYER_MARKER
end

def computer_select_square(line, board, marker_type)
  if board.values_at(*line).count(marker_type) == 2
    board.select { |k, v| line.include?(k) && v == INITIAL_MARKER }.keys.first
  else
    nil
  end
end

def computer_turn(board)
  square = nil

  WINNING_LINES.each do |line|
    square = computer_select_square(line, board, PLAYER_MARKER)
    break if square
  end

  if !square
    WINNING_LINES.each do |line|
      square = computer_select_square(line, board, COMPUTER_MARKER)
      break if square
    end
  end

  if !square
    square = empty_squares(board).sample
  end

  board[square] = COMPUTER_MARKER
end

def board_full?(board)
  empty_squares(board).empty?
end

def detect_winner(board)
  WINNING_LINES.each do |line|
    if board.values_at(*line).count(PLAYER_MARKER) == 3
      return 'Player'
    elsif board.values_at(*line).count(COMPUTER_MARKER) == 3
      return 'Computer'
    end
  end
  nil
end

def someone_won?(board)
  detect_winner(board)
end

def round_score_msg(player_score, computer_score)
  "Player [#{player_score}] v [#{computer_score}] Computer"
end

def game_winner_msg(player_score, computer_score)
  if player_score > computer_score
    'Player won the game!'
  else
    'Computer won the game!'
  end
end

def joinor(array, delimeter=', ' , word='or')
  string = ''
  i = 1
  array.each do |value|
    if i < array.count
      string = string + value.to_s + delimeter
    else
      string = string + word + ' ' + value.to_s
    end
    i += 1
  end
  return string
end

board = initialize_board
player_score = 0
computer_score = 0

# Keeping playing until user chooses to quit
loop do

  # Play game until player or computer wins 5 rounds
  loop do

    # Take turns until board is full or somebody wins rounds
    loop do
      display_board(board)
      player_turn(board)
      break if someone_won?(board) || board_full?(board)
      computer_turn(board)
      break if someone_won?(board) || board_full?(board)
    end

    display_board(board)

    if someone_won?(board)
      round_winner = detect_winner(board)
      puts "#{round_winner} won the round!"
      round_winner == 'Player' ? player_score += 1 : computer_score += 1
    else
      puts 'Round was tied!'
    end

    puts round_score_msg(player_score, computer_score)
    break if player_score == MAX_ROUNDS || computer_score == MAX_ROUNDS

    puts "Press any key to play the next round"
    gets.chomp
    board = initialize_board
  end

  puts game_winner_msg(player_score, computer_score)
  puts 'Would you like to play another game? [Y]es or [N]o'
  break unless gets.chomp.downcase.start_with?('y')
end

puts 'Thank you for playing. Good bye!'
