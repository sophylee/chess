# encoding: UTF-8

require "colorize"
require 'io/console'
require './lib/player'
require './lib/pieces'
require './lib/board'

class Game
  attr_accessor :turn, :row, :col, :selected_piece

  def initialize
    @board = Board.new(self)
    @row, @col = [7,1]
    @turn = :white
    @row
  end

  def play
    valid_keys = ["w", "a", "s", "d", "q", " ", "`", "r"]
    input = nil
    @board.print_board
    puts "Use WASD keys to move. Space to select/place piece. ` to save."
    @selected_piece = nil
    # until self.won?
    while true
      begin
        input = nil
        until valid_keys.include?(input)
          input = STDIN.getch
        end
        if input == "q"
          puts "quitting"
          return
        elsif input == "r"
          @selected_piece = nil
        elsif input == " "
          check_move
        else
          check_input(input)
        end
        input = nil
        @board.print_board
        puts "Use WASD keys to move. space to select/place a piece, ` to save"
      rescue  Exception => e
        puts "Invalid move. Please try again."
        raise e
        retry
      end
    end
    @board.print_board
  end

  def check_input(input)
    if input == "`"
      return self.save
    elsif input == "w" && @row > 0
      @row -= 1
    elsif input == "a" && @col > 0
      @col -= 1
    elsif input == "s" && @row < @board.board.count - 1
      @row += 1
    elsif input == "d" && @col < @board.board.first.count - 1
      @col += 1
    end
  end

  def check_move
    if @selected_piece.nil? && @board.board[@row][@col].color == @turn
      @selected_piece = @board.board[@row][@col]
    elsif @selected_piece.nil? && @board.board[@row][@col].color != @turn
      raise "Wrong color. Please try again."
      @selected_piece = nil
    elsif @selected_piece.nil? && @board.board[@row][@col].nil?
      raise "No piece to select. Please try again."
      @selected_piece = nil
    else
      if check?
        get_out_of_check
      else
        try_piece(@board, @selected_piece)
      end
    end
  end

  def switch_turn
    if self.turn == :white
      self.turn = :black
    else
      self.turn = :white
    end
  end

  def try_piece(imaginary_board, piece)
    if piece.show_possible_moves.any? { |move| move == [@row, @col] } && imaginary_board.board[@row][@col].nil?
      imaginary_board[piece.location] = nil
      imaginary_board.board[@row][@col] = piece       # update the board with newly placed piece
      piece.location = [@row, @col]
      if piece.is_a?(Pawn)
        piece.moved = true
      end
      @selected_piece = nil
      self.switch_turn
    elsif piece.show_possible_moves.any? { |move| move == [@row, @col] } && !imaginary_board.board[@row][@col].nil?
      kill_piece([@row, @col])
      imaginary_board[piece.location] = nil
      imaginary_board.board[@row][@col] = piece       # update the board with newly placed piece
      piece.location = [@row, @col]
      if piece.is_a?(Pawn)
        piece.moved = true
      end
      @selected_piece = nil
      self.switch_turn
    else
      raise "Invalid move. Please try again."
      piece = nil
    end
  end

  def get_out_of_check
    @test_board = @board.dup
    @select_piece = @selected_piece.dup
    @select_piece.board = @test_board
    escape_possible?
    try_piece(@test_board, @select_piece)
    unless @test_board.game.check?
      @board = @test_board
      @selected_piece = @select_piece
    end
    self.switch_turn
  end

  def kill_piece(location)
    @board[location] = nil
  end

  # def won?
  #   if check? #&& !escape_possible?
  #     return true
  #   elsif check?
  #     print "#{self.turn} is in check."
  #     until valid_move?
  #       # only let player play valid move
  #     end
  #   end
  # end

  def check?
    king_location = nil
    @board.board.each do |row|
      row.each do |tile|
        if tile.is_a?(Piece) && (tile.type == "♔" || tile.type == "♚") && (tile.color == self.turn) ## cont from here
          king_location = tile.location
        end
      end
    end

    opponent_possible_moves = []
    @board.board.each do |row|
      row.each do |tile|
        if tile.is_a?(Piece) && tile.color != self.turn
          opponent_possible_moves += tile.show_possible_moves
        end
      end
    end

    return true if opponent_possible_moves.include?(king_location)

    false
  end

  # def escape_possible?
  #   @test_board.board.each do |row|
  #     row.each do |tile|
  #       if tile.is_a?(Piece) && (tile.color == self.turn)
  #         tile.show_possible_moves.each do |move|
  #           try_piece(@test_board, tile)
  #           unless @test_board.game.check?
  #             self.switch_turn
  #             return false
  #           end
  #         end
  #       end
  #     end
  #   end
  #   self.switch_turn
  #   true
  # end

end

game = Game.new
game.play