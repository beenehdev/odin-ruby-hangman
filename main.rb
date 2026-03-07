# frozen_string_literal: true

require_relative 'lib/dictionary'
require_relative 'lib/game'

dictionary = Hangman::Dictionary.new
game = Hangman::Game.new(dictionary)

game.start
