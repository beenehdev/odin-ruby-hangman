# frozen_string_literal: true

module Hangman
  # Responsible for orchestrating gameflow of hangman
  class Game
    def initialize(interface, dictionary, save_manager)
      @interface = interface
      @dictionary = dictionary
      @save_manager = save_manager
    end

    def start
      @interface.welcome
    end
  end
end
