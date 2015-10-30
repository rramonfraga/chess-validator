require 'pry'

module RightMovement
  def right_movemnt? board, origin, destination
    orientation = orientation(origin, destination)
    orientation[0] == 0 || orientation[1] == 0
  end
end


module DiagonalMovement
  def diagonal_movemnt? board, origin, destination
    orientation = orientation(origin, destination)
    orientation[0] == orientation[1]
  end
end


#------------------------------------------------
#--------------------PIECES----------------------
#------------------------------------------------

class Piece
  def initialize color=:black
    @color = color
  end

  def orientation origin, destination
    vector = []
    destination.each_with_index do |position, index|
      vector.push((position - origin[index]).abs)
    end
    vector
  end

  def is_empty? board, destination
    board[destination[0]][destination[1]] == nil
  end
end


class Rook < Piece
  include RightMovement
  def check_move? board, origin, destination
    orientation = orientation(origin, destination)
    if right_movemnt? board, origin, destination
      is_empty? board, destination
    end
  end
end

class Queen < Piece
  include RightMovement
  include DiagonalMovement
  def check_move? board, origin, destination
    orientation = orientation(origin, destination)
    if (right_movemnt? board, origin, destination) || (diagonal_movemnt? board, origin, destination)
      is_empty? board, destination
    end
  end
end

class Bishop < Piece
  include DiagonalMovement
  def check_move? board, origin, destination
    orientation = orientation(origin, destination)
    if diagonal_movemnt? board, origin, destination
      is_empty? board, destination
    end
  end
end

class King < Piece
  def check_move? board, origin, destination
    orientation = orientation(origin, destination)
    if (orientation[0] == 1 || orientation[1] == 1)
      is_empty? board, destination
    end
  end
end

class Knigth < Piece
  def check_move? board, origin, destination
    orientation = orientation(origin, destination)
    if ( (orientation[0] == 1 &&  orientation[1] == 2) || (orientation[0] == 2 &&  orientation[1] == 1) )
      is_empty? board, destination
    end
  end
end

class Pawn < Piece
  def check_move? board, origin, destination
    orientation = orientation(origin, destination)
    if( (origin[0] == 1)  && (destination[0] == 3) && (@color == :black))
      is_empty? board, destination
    elsif( (origin[0] == 1)  && (destination[0] == 3) && (@color == :white) )
      is_empty? board, destination
    elsif( ((destination[0] - origin[0]) == 1) && (@color == :black))
      is_empty? board, destination
    elsif((destination[0] - origin[0]) == -1 && (@color == :white))
      is_empty? board, destination
    end
  end
end




#------------------------------------------------
#-------------------BOARD------------------------
#------------------------------------------------


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
    if @pieces[piece].new.check_move? @board, origin, destination
      puts "LEGAL"
    else
      puts "ILLEGAL"
    end
  end
end


pieces = {
  bR: Rook,
  wR: Rook,
  bQ: Queen,
  wQ: Queen,
  bB: Bishop,
  wB: Bishop,
  bK: King,
  wK: King,
  bN: Knigth,
  wN: Knigth,
  bP: Pawn,
  wP: Pawn
}


board = Board.new(pieces, "board_test.txt")
board.load_board
board.show_board
board.check_move(:bP,[1,0],[3,0])

