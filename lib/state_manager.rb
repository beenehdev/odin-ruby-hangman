# frozen_string_literal: true

module Hangman
  # Responsible for persisting state of game values
  class StateManager
    attr_accessor :secret, :guesses, :round_running, :max_incorrect

    def initialize
      @max_incorrect = 8
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
