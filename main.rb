# frozen_string_literal: true

require_relative 'lib/dictionary'
require_relative 'lib/interface'
require_relative 'lib/game'

dictionary = Hangman::Dictionary.new
interface = Hangman::Interface.new
game = Hangman::Game.new(interface, dictionary)

game.start
