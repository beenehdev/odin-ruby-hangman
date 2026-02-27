# frozen_string_literal: true

module Hangman
  # Responsible for orchestrating gameflow of hangman
  class Game
    attr_reader :round_running, :save_exists

    def initialize(interface, dictionary, save_manager)
      @interface = interface
      @dictionary = dictionary
      @save_manager = save_manager

      @alphabet = (a..z).to_a
      @max_incorrect = 8
      @round_running = false
    end

    def save_game
    end

    def load_game
    end

    def exit_game
    end

    def input_director(arg)
      result = @interface.ask_user(arg)

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

    def finish_game(secret, guesses)
      does stuff etc
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

      finish_game(secret, guesses)
    end
  end
end
