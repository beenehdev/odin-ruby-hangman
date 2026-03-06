# frozen_string_literal: true

require_relative 'save_manager'
require_relative 'state_manager'

module Hangman
  # Responsible for orchestrating gameflow of hangman
  class Game
    attr_reader :round_running

    def initialize(interface, dictionary)
      @interface = interface
      @dictionary = dictionary

      @max_incorrect = 8
      @alphabet = ('a'..'z').to_a
      @play_again = false

      @save_manager = SaveManager.New
      @state_manager = StateManager.New(@max_incorrect)
    end

    def save_game
      # need to store secret and array of guesses in an array of [a, b[c, d, e]]
      # needs secret and guesses, make instance variables and retool?
    end

    def load_game
      data_hash = @save_manager.load
      @state_manager.secret = data_hash[0]
      @state_manager.guesses = data_hash[1]
    end

    def exit_game
      exit
    end

    def input_director(*args)
      result = @interface.ask_user(*args)

      return result unless @interface.special_commands.include?(result)

      case result
      when 'save' then save_game
      when 'load' then load_game
      when 'exit' then exit_game
      end

      nil
    end

    def set
      @interface.set
      @state_manager.secret = @dictionary.random_word
      @interface.draw_cli_board(@state_manager.secret, @state_manager.guesses)
    end

    def round
      @interface.guess
      guess = nil

      loop do
        guess = input_director(@alphabet)

        next if guess.nil?
        next if @state_manager.guesses.include?(guess)

        @state_manager.guesses << guess
        break
      end

      @interface.draw_cli_board(@state_manager.secret, @state_manager.guesses)
    end

    def finish
      @state_manager.win? ? @interface.win : @interface.lose

      @interface.end
      result = input_director('yes', 'no')

      @play_again = true if result == 'yes'
      @play_again = false if result == 'no'
    end

    def play
      @interface.secret = set
      @round_running = true

      loop do
        round
        break if [true, false].include?(@state_manager.win_or_lose?)
      end
      @round_running = false

      finish
    end

    def start
      @interface.start

      loop do
        next if input_director('start').nil?

        break
      end

      loop do
        play
        break unless @play_again == true
      end

      exit_game
    end
  end
end
