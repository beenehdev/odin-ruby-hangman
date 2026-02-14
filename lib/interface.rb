# frozen_string_literal: true

module Hangman
  # Responsible for translating and validating between human interaction and game actions.
  class Interface
    def initialize
      @save = false
      @alphabet = (a..z).to_a
      @special_commands = %w[save load exit]
    end

    def ask_user(*valid_options)
      valid_options.map!(&:downcase)
      loop do
        print '> '
        input = gets.chomp.strip.downcase

        return input if valid_options.include?(input)

        puts "Invalid input. Please type #{valid_options.join(' or ')}."
      end
    end

    def welcome
      puts 'Welcome to Hangman! Type "play", "load", or "exit".'
      ask_user('play', *@special_commands)
    end

    def guess_letter
      ask_user(*@alphabet, *@special_commands)
    end
  end
end
