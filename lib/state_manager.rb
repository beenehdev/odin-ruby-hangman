# frozen_string_literal: true

module Hangman
  # Responsible for persisting state of game values to allow dynamic access and restoration thru save manager
  class StateManager
    attr_accessor :secret, :guesses, :round_running

    def initialize(max_incorrect)
      @max_incorrect = max_incorrect
      @secret = []
      @guesses = []
      @round_running = false
    end

    def win_or_lose?
      if (@secret - @guesses).empty?
        true
      elsif (@guesses - @secret).count >= @max_incorrect
        false
      end
    end
  end
end
