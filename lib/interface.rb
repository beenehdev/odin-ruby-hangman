# frozen_string_literal: true

module Hangman
  # Responsible for translating and validating between human interaction and game actions.
  class Interface
    attr_reader :special_commands, :alphabet

    def initialize
      @save = false

      @max_incorrect = 8
      @special_commands = %w[save load exit]
    end

    def ask_user(*valid_options)
      valid_options.flatten.map!(&:downcase)
      loop do
        print '> '
        input = gets.chomp.strip.downcase

        return input if valid_options.flatten.include?(input) || @special_commands.include?(input)

        puts 'Invalid input.'
      end
    end

    def draw_cli_board(secret, guesses)
      answers = guesses.dup
      secret.each do |i|
        if guesses.include?(i)
          print "#{i} "
          answers.delete(i)
        else
          print '_ '
        end
      end

      puts "\n Incorrect letters: #{answers}. Lives left: #{@max_incorrect - answers.length}"
    end

    def warn_duplicate
      puts 'Duplicate letter, please re-enter a new guess.'
    end

    def warn_load
      puts 'No save-data to load!'
    end

    def warn_save
      puts 'There is no running game to save!'
    end

    def start
      puts 'Welcome to Hangman! Type "start", "load", or "exit".'
    end

    def resume
      puts 'Previous save loaded! Resuming from previous position.'
    end

    def set
      puts "The word is set! \nRemember, you can 'save', 'load', or 'exit' at any time!"
    end

    def guess
      puts 'Guess a letter!'
    end

    def save
      puts 'successfully saved!'
    end

    def win
      puts 'You won!'
    end

    def lose
      puts 'You lost!'
    end

    def end(secret)
      puts "The word was #{secret.join}!"
      puts "Would you like to play again? Type 'yes', or 'no'"
    end

    def exit
      puts 'Closing game!'
    end
  end
end
