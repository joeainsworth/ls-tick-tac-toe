require 'pry'

INITIAL_MARKER  = ' '
PLAYER_MARKER   = 'X'
COMPUTER_MARKER = 'O'
WINNING_LINES   = [[1, 2, 3], [4, 5, 6], [7, 8, 9], [1, 4, 7], [2, 5, 8],
                   [3, 6, 9], [1, 5, 9], [7, 5, 3]]

def display_board(board)
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
    puts ("Choose a square (#{empty_squares(board).join(', ')}):")
    square = gets.chomp.to_i
    break if empty_squares(board).include?(square)
    puts "Sorry this is not a valid square."
  end
  board[square] = PLAYER_MARKER
end

def computer_turn(board)
  board[empty_squares(board).sample] = COMPUTER_MARKER
  board
end

def board_full?(board)
  empty_squares(board).empty?
end

def detect_winner(board)
  # check to see if same marker goes across
  WINNING_LINES.each do |line|
    if board[line[0]] == PLAYER_MARKER &&
       board[line[1]] == PLAYER_MARKER &&
       board[line[2]] == PLAYER_MARKER
      return 'Player'
    elsif board[line[0]] == COMPUTER_MARKER &&
          board[line[1]] == COMPUTER_MARKER &&
          board[line[2]] == COMPUTER_MARKER
      return 'Computer'
    end
  end
  nil
end

def someone_won?(board)
  detect_winner(board)
end

def outcome_msg(player_score, computer_score)
  if player_score > computer_score
    'Player scored the most rounds!'
  elsif player_score < computer_score
    'Computer scored the most rounds!'
  else
    'Nobody won overall, was a tie!'
  end
end

board = initialize_board
player_score = 0
computer_score = 0

begin
  loop do
    system 'clear'
    display_board(board)
    player_turn(board)
    break if someone_won?(board) || board_full?(board)

    computer_turn(board)
    break if someone_won?(board) || board_full?(board)
  end

  system 'clear'
  display_board(board)

  if someone_won?(board)
    round_winner = detect_winner(board)
    puts "#{round_winner} won!"
    round_winner == 'Player' ? player_score += 1 : computer_score += 1
  else
    puts "It was a tie!"
  end

  board = initialize_board
  puts "Player [#{player_score}] v [#{computer_score}] Computer"
  puts 'Would you like to play again? [Y]es or [N]o'
end while gets.chomp.downcase.start_with?('y')

outcome_msg(player_score, computer_score)

puts 'Thank you for playing. Good bye!'
