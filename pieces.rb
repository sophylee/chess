# encoding: UTF-8

require "colorize"

class Piece
  attr_accessor :location, :board
  attr_reader :color, :type

  HORIZONTAL = [[0, 1], [0, -1]]
  VERTICAL = [[1, 0], [-1, 0]]
  DIAGONAL = [[1, 1], [1, -1], [-1, -1], [-1, 1]]

  def initialize(board, color, location = nil)
    @board = board
    @color = color
    @location = location
  end

  def in_bounds?(possible_pos)
    possible_pos[0].between?(0,7) && possible_pos[1].between?(0,7)
  end


  def valid_move?(potential_move)
    in_bounds?(potential_move) && (@board[potential_move].nil? ||
                                   @board[potential_move].color != self.color)
  end

end

class SlidingPiece < Piece
  def initialize(board, color, location = nil)
    super(board, color, location)
  end

  def show_possible_moves(move_type)
    possible_moves = []
    move_type.each do |move|
      potential_move = [self.location[0] + move[0], self.location[1] + move[1]]
      while valid_move?(potential_move)
        possible_moves << potential_move
        potential_move = [potential_move[0] + move[0], potential_move[1] + move[1]]
        if @board[possible_moves.last].is_a?(Piece) && @board[possible_moves.last].color == self.color
          break
        end
      end
    end
    possible_moves
  end
end

class Queen < SlidingPiece

  def initialize(board, color, location)
    super(board, color, location)
  end

  def type
    self.color == :white ? @type = "♕" : @type = "♛"
  end

  def show_possible_moves
    super(HORIZONTAL) + super(VERTICAL) + super(DIAGONAL)
  end

end

class Rook < SlidingPiece

  def initialize(board, color, location)
    super(board, color, location)
  end

  def type
    self.color == :white ? @type = "♖" : @type = "♜"
  end

  def show_possible_moves
    super(HORIZONTAL) + super(VERTICAL)
  end
end

class Bishop < SlidingPiece

  def initialize(board, color, location)
    super(board, color, location)
  end

  def type
    self.color == :white ? @type = "♗" : @type = "♝"
  end

  def show_possible_moves
    super(DIAGONAL)
  end

end

class SteppingPiece < Piece

  def initialize(board, color, location = nil)
    super(board, color, location)
  end

  def show_possible_moves(move_type)
    possible_moves = []
    move_type.each do |move|
      potential_move = [self.location[0] + move[0], self.location[1] + move[1]]
      if valid_move?(potential_move)
        possible_moves << [self.location[0] + move[0], self.location[1] + move[1]]
      end
    end
    possible_moves
  end

end

class Knight < SteppingPiece

  KNIGHT = [[2, 1], [2, -1], [1, 2], [1, -2], [-2, -1], [-2, 1], [-1, 2], [-1, -2]]

  def initialize(board, color, location)
    super(board, color, location)
  end

  def type
    self.color == :white ? @type = "♘" : @type = "♞"
  end

  def show_possible_moves
    super(KNIGHT)
  end

end

class King < SteppingPiece

  def initialize(board, color, location = nil)
    super(board, color, location)
  end

  def type
    self.color == :white ? @type = "♔" : @type = "♚"
  end


  def show_possible_moves
    super(HORIZONTAL) + super(VERTICAL) + super(DIAGONAL)
  end

end

class Pawn < Piece
  attr_accessor :moved


  def initialize(board, color, location = nil, moved = false)
    super(board, color, location)
  end

  def type
    self.color == :white ? @type = "♙" : @type = "♟"
  end

  def show_possible_moves
    possible_moves = []

    if self.color == :white
      fwd_vertical = -1
      fwd_diagonal = [[-1, 1], [-1, -1]]
    else
      fwd_vertical = 1
      fwd_diagonal = [[1, 1], [1, -1]]
    end

    self.moved ? loop_steps = 1 : loop_steps = 2
    potential_move = [self.location[0] + fwd_vertical, self.location[1]]
    loop_steps.times do
      if in_bounds?(potential_move) && @board[potential_move].nil?
        possible_moves << potential_move
        potential_move = [potential_move[0] + fwd_vertical, potential_move[1]]
      end
    end

    fwd_diagonal.each do |move|
      potential_move = [self.location[0] + move[0], self.location[1] + move[1]]
      unless @board.board[potential_move[0]].nil? || @board[potential_move].nil?
        if @board[potential_move].color != self.color
          possible_moves << potential_move
        end
      end
    end

    possible_moves
  end
end