require 'pry'

INITIAL_MARKER  = ' '
PLAYER_MARKER   = 'X'
COMPUTER_MARKER = 'O'
WINNING_LINES   = [[1, 2, 3], [4, 5, 6], [7, 9, 9], [1, 5, 9], [7, 5, 3],
                   [1, 3, 5], [2, 5, 8], [3, 6, 9]]

def display_board(board)
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

def detect_winner?(board)
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
  !!detect_winner?(board)
end

board = initialize_board
display_board(board)

loop do
  player_turn(board)
  computer_turn(board)
  display_board(board)
  break if someone_won?(board) || board_full?(board)
end
