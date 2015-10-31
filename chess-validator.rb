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
    elsif( (origin[0] == 6)  && (destination[0] == 4) && (@color == :white) )
      is_empty? board, destination
    elsif( (orientation[0] == 1 && orientation[1] == 0) && (@color == :black))
      is_empty? board, destination
    elsif( (orientation[0] == -1 && orientation[1] == -1) && (@color == :white))
      is_empty? board, destination
    end
  end
end




#------------------------------------------------
#-------------------BOARD------------------------
#------------------------------------------------


class Board
  def initialize pieces, positions, file_board, file_movement
    @pieces = pieces
    @positions = positions
    @board = Array.new(8, Array.new(8, nil))
    @file_board = file_board
    @file_movement = file_movement
  end

  def load_movements
    movement = []
    movements = IO.read(@file_movement).split("\n")
    new_movements = movements.each do |item|
      item.split("\n")
    end
    new_movements
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
    rows = IO.read(@file_board).split("\n")
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

  def check_color piece
    if piece[0] == "b"
      :black
    else
      :white
    end
  end

  def check_move piece, origin, destination
    color = check_color piece
    #binding.pry
    if @pieces[piece].new(color).check_move? @board, origin, destination
      puts "LEGAL"
    else
      puts "ILLEGAL"
    end
  end

  def checks_all_the_movements
    piece = ""
    movements = load_movements.map do |item|
      item.split " "
    end
    movements.each do |movement|
      origin = @positions[movement[0].to_sym]
      destination = @positions[movement[1].to_sym]
      piece = @board[origin[0]][origin[1]]
      #binding.pry
      check_move(piece.to_sym, origin, destination)
      #binding.pry
    end
  end

end


pieces = {
  bR: Rook, wR: Rook, 
  bQ: Queen, wQ: Queen,
  bB: Bishop, wB: Bishop,
  bK: King, wK: King,
  bN: Knigth, wN: Knigth,
  bP: Pawn, wP: Pawn
}

positions = { a8: [0,0], b8: [0,1], c8: [0,2], d8: [0,3], e8: [0,4], f8: [0,5], g8: [0,6], h8: [0,7],
              a7: [1,0], b7: [1,1], c7: [1,2], d7: [1,3], e7: [1,4], f7: [1,5], g7: [1,6], h7: [1,7],
              a6: [2,0], b6: [2,1], c6: [2,2], d6: [2,3], e6: [2,4], f6: [2,5], g6: [2,6], h6: [2,7],
              a5: [3,0], b5: [3,1], c5: [3,2], d5: [3,3], e5: [3,4], f5: [3,5], g5: [3,6], h5: [3,7],
              a4: [4,0], b4: [4,1], c4: [4,2], d4: [4,3], e4: [4,4], f4: [4,5], g4: [4,6], h4: [4,7],
              a3: [5,0], b3: [5,1], c3: [5,2], d3: [5,3], e3: [5,4], f3: [5,5], g3: [5,6], h3: [5,7],
              a2: [6,0], b2: [6,1], c2: [6,2], d2: [6,3], e2: [6,4], f2: [6,5], g2: [6,6], h2: [6,7],
              a1: [7,0], b1: [7,1], c1: [7,2], d1: [7,3], e1: [7,4], f1: [7,5], g1: [7,6], h1: [7,7]
}


board = Board.new(pieces, positions, "board_test.txt", "movements.txt")
board.load_board
board.show_board
#board.check_move(:bP,[1,0],[3,0])
board.checks_all_the_movements

