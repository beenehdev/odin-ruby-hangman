# frozen_string_literal: true

module Hangman
  # Responsible for persisting state of game values to allow dynamic access and restoration thru save manager
  class SaveManager
    attr_accessor :secret, :guesses, :round_running

    def initialize(max_incorrect)
      @max_incorrect = max_incorrect
      @secret = []
      @guesses = []
      @round_running = false
    end

    def win?
      if (@state_manager.secret - @state_manager.guesses).empty?
        true
      elsif (@state_manager.guesses - @state_manager.secret).count >= @max_incorrect
        false
      else
        'Third return value'
      end
    end
  end
end
