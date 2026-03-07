# frozen_string_literal: true

require 'json'

module Hangman
  # Responsible for saving and loading game data
  class SaveManager
    PATH = File.expand_path('../saves/save.json', __dir__)

    attr_accessor :has_savedata, :is_loading

    def initialize
      @has_savedata = File.exist?(PATH) && !File.empty?(PATH)
      @is_loading = false
    end

    def save(data_snapshot)
      File.write(PATH, JSON.generate(data_snapshot))
      @has_savedata = true
    end

    def load
      return nil unless @has_savedata

      @is_loading = true

      file = File.read(PATH)
      JSON.parse(file)
    end
  end
end
