
class Piece
  def initialize
  end
end

class Rook < Piece
  def initialize
  end
  def check_move board, origin, destination

  end
end

class Board
  def initialize file_name
    @board = Array.new(8, Array.new(8, nil))
    @file_name = file_name
  end

  def load_board
    cell = Array.new(8, Array.new(8, nil))
    rows = IO.read(@file_name).split("\n")
    cell = rows.map do |row|
      row.split
    end
    @board = cell
  end

  def show_board
    @board.each do |row|
      row.each do |cell|
          print cell + " "
      end
      puts ""
    end
  end
end


pieces = {
  bR: Rook,
  wR: Rook
}

 board = Board.new("board_test.txt")
 board.load_board
 board.show_board
