require 'pry'
class Piece
  def initialize
  end
  def orientation origin, destination
    vector = []
    destination.each_with_index do |position, index|
      vector.push(position - origin[index])
    end
    vector
  end
  def is_empty? board, destination
    board[destination[0]][destination[1]] == nil
  end
end

class Rook < Piece
  def initialize
  end
  def check_move? board, origin, destination
    orientation = orientation(origin, destination)
    if orientation[0] == 0
      is_empty? board, destination
    elsif orientation[1] == 0
      is_empty? board, destination
    else
      false
    end
  end
end

class Board
  def initialize pieces, file_name
    @pieces = pieces
    @board = Array.new(8, Array.new(8, nil))
    @file_name = file_name
  end

  def nullify_board board
    board.map do |row|
      row.map do |cell|
        if cell == "--"
          cell = nil
        else
          cell
        end
      end
    end
  end

  def load_board
    cell = Array.new(8, Array.new(8, nil))
    rows = IO.read(@file_name).split("\n")
    cell = rows.map do |row|
      row.split
    end
    @board = nullify_board cell
  end

  def show_board
    @board.each do |row|
      row.each do |cell|
        if cell == nil
          print "-- "
        else
          print cell + " "
        end
      end
      puts ""
    end
  end

  def check_move piece, origin, destination
    binding.pry
    if @pieces[piece].new.check_move? @board, origin, destination
      puts "LEGAL"
    else
      puts "ILLEGAL"
    end
  end
end


pieces = {
  bR: Rook,
  wR: Rook
}
a=[0,0]
b=[0,7]
board = Board.new(pieces, "board_test.txt")
board.load_board
board.show_board
board.check_move(:bR,[0,0],[0,6])

