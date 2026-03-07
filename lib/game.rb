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

      @save_manager = SaveManager.new
      @state_manager = StateManager.new(@max_incorrect)
    end

    def save_game
      unless @round_running
        @interface.warn_save
        return nil
      end

      data_hash = [@state_manager.secret, @state_manager.guesses]
      @save_manager.save(data_hash)

      @interface.save
    end

    def load_game
      unless @save_manager.has_savedata
        @interface.warn_load
        return nil
      end

      data_hash = @save_manager.load
      @state_manager.secret = data_hash[0]
      @state_manager.guesses = data_hash[1]

      resume
    end

    def exit_game
      @interface.exit

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
      unless @save_manager.is_loading
        @state_manager.secret = @dictionary.random_word
        @state_manager.guesses = []
      end
      @interface.draw_cli_board(@state_manager.secret, @state_manager.guesses)
    end

    def round
      @interface.guess
      guess = nil

      loop do
        guess = input_director(@alphabet)

        if @state_manager.guesses.include?(guess)
          @interface.warn_duplicate
          next
        end
        next if guess.nil?

        @state_manager.guesses << guess
        break
      end

      @interface.draw_cli_board(@state_manager.secret, @state_manager.guesses)
    end

    def finish
      @state_manager.win_or_lose? ? @interface.win : @interface.lose

      @interface.end(@state_manager.secret)
      result = input_director('yes', 'no')

      @play_again = result == 'yes'
    end

    def play
      set
      @round_running = true

      loop do
        round
        break unless @state_manager.win_or_lose?.nil?
      end
      @round_running = false

      finish
    end

    def run_game_loop
      loop do
        play
        @save_manager.is_loading = false
        break unless @play_again
      end
    end

    def start
      @interface.start

      loop do
        next if input_director('start').nil?

        break
      end

      run_game_loop
      exit_game
    end

    def resume
      @interface.resume
      run_game_loop
      exit_game
    end
  end
end
