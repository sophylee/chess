# encoding: UTF-8

require "colorize"

class Player
  attr_accessor :name

  def initialize(name)
    @name = name
  end

  def move
    puts "Select a piece: "
    start_pos = gets.chomp
    puts "Where would you like to move it?"
    end_pos = gets.chomp
  end
end