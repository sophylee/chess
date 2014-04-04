# encoding: UTF-8

require "colorize"

class Board
  attr_accessor :board
  attr_reader :game

  def initialize(game)
    @board = Array.new(8) { Array.new(8) }
      set_pawns
      set_queens
      set_kings
      set_bishops
      set_knights
      set_rooks
    @game = game
  end

  def dup
    dup_board = Board.new(@game)
    self.board.each_with_index do |row, row_idx|
      row.each_with_index do |col, col_idx|
        dup_board.board[row_idx][col_idx] = self.board[row_idx][col_idx]
        next if col.nil?
        dup_board.board[row_idx][col_idx].board = dup_board
      end
    end
    dup_board
  end

  def [](pos)
    row, col = pos
    @board[row][col]
  end

  def []=(pos, piece)
    row, col = pos
    @board[row][col] = piece
  end

  def show_board
    # system "clear"
    user_board = Array.new(8) { Array.new(8, "_") }
    self.board.each_with_index do |row, r_idx|
      row.each_with_index do |tile, c_idx|
        if tile.nil?
          user_board[r_idx][c_idx] = "_"
        else
          user_board[r_idx][c_idx] = tile.type
        end
      end
    end

    current_value = user_board[@game.row][@game.col]
    user_board[@game.row][@game.col] = current_value.on_red

    user_board
  end

  def print_board
    show_board.each_with_index do |row, i|
      puts row.map(&:to_s).join("  ")
    end
  end

  def set_queens
    self[[0,3]] = Queen.new(self, :black, [0,3])
    self[[7,3]] = Queen.new(self, :white, [7,3])
  end

  def set_kings
    self[[0,4]] = King.new(self, :black, [0,4])
    self[[7,4]] = King.new(self, :white, [7,4])
  end

  def set_bishops
    black_bishops = [2,5].map {|col| Bishop.new(self, :black, [0, col]) }
    black_bishops.each {|piece| self[piece.location] = piece }
    white_bishops = [2,5].map {|col| Bishop.new(self, :white, [7, col]) }
    white_bishops.each {|piece| self[piece.location] = piece }
  end

  def set_knights
    black_knights = [1,6].map {|col| Knight.new(self, :black, [0, col]) }
    black_knights.each {|piece| self[piece.location] = piece }

    white_knights = [1,6].map {|col| Knight.new(self, :white, [7, col]) }
    white_knights.each {|piece| self[piece.location] = piece }
  end

  def set_rooks
    black_rooks = [0,7].map {|col| Rook.new(self, :black, [0, col]) }
    black_rooks.each {|piece| self[piece.location] = piece }

    white_rooks = [0,7].map {|col| Rook.new(self, :white, [7, col]) }
    white_rooks.each {|piece| self[piece.location] = piece }
  end

  def set_pawns
    black_pawns = (0..7).map { |col| Pawn.new(self, :black, [1,col]) }
    black_pawns.each {|piece| self[piece.location] = piece }

    white_pawns = (0..7).map { |col| Pawn.new(self, :white, [6,col]) }
    white_pawns.each {|piece| self[piece.location] = piece }
  end

end