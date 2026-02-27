# frozen_string_literal: true

module Hangman
  # Responsible for translating and validating between human interaction and game actions.
  class Interface
    attr_reader :special_commands, :alphabet

    def initialize
      @save = false

      @special_commands = %w[save load exit]
    end

    def ask_user(*valid_options)
      valid_options.map!(&:downcase)
      loop do
        print '> '
        input = gets.chomp.strip.downcase

        return input if valid_options.include?(input) || @special_commands.include?(input)

        puts 'Invalid input.'
      end
    end

    def welcome
      puts 'Welcome to Hangman! Type "start", "load", or "exit".'
    end

    def start
      puts "The word is set! \nRemember, you can 'save', 'load', or 'exit' at any time!"
    end

    def guess
      puts 'Guess a letter!'
    end

    def draw_cli_board(secret, guesses)
    end
  end
end
