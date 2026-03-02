# frozen_string_literal: true

module Hangman
  # Responsible for orchestrating gameflow of hangman
  class Game
    attr_reader :round_running

    def initialize(interface, dictionary, save_manager)
      @interface = interface
      @dictionary = dictionary
      @save_manager = save_manager

      @alphabet = ('a'..'z').to_a
      @max_incorrect = 8
      @round_running = false
    end

    def save_game
      # need to store secret and array of guesses in an array of [a, b[c, d, e]]
    end

    def load_game
      # need to load secret (array of values), array of guesses [a[1, 2, 3], b[c, d, e]], then use to restore state in play
      data_hash = @save_manager.load
      secret = data_hash[0]
      guesses = data_hash[1]
    end

    def exit_game
      exit!
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

    def welcome
      @interface.welcome

      loop do
        result = input_director('start')

        next if result.nil?

        break
      end
    end

    def start
      @interface.start
      secret = @dictionary.random_word
      @interface.draw_cli_board(secret, [])

      secret
    end

    def round(secret, guesses)
      @interface.guess
      guess = nil

      loop do
        guess = input_director(@alphabet)

        next if guess.nil?
        next if guesses.include?(guess)

        guesses << guess
        break
      end

      @interface.draw_cli_board(secret, guesses)
    end

    def finish(secret, guesses)
      if (secret - guesses).empty?
        @interface.win
      elsif (guesses - secret).count >= @max_incorrect
        @interface.lose
      end

      @interface.end
      result = input_director('yes', 'no')

      play if result == 'yes'
      exit_game if result == 'no'
    end

    def play
      welcome
      secret = start
      guesses = []
      @round_running = true

      loop do
        round(secret, guesses)
        break if (secret - guesses).empty? || (guesses - secret).count >= @max_incorrect
      end
      @round_running = false

      finish(secret, guesses)
    end
  end
end
