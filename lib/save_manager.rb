# frozen_string_literal: true

require 'json'

module Hangman
  # Responsible for saving and loading game data
  class SaveManager
    PATH = File.expand_path('../saves/save.json', __dir__)

    attr_reader :has_savedata

    def initialize
      @has_savedata = File.exist?(PATH) && !File.empty?(PATH)
    end

    def save(data_snapshot)
      File.write(PATH, JSON.generate(data_snapshot))
      @has_savedata = true
    end

    def load
      return nil unless @has_savedata

      file = File.read(PATH)
      JSON.parse(file)
    end
  end
end
