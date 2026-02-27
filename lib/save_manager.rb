# frozen_string_literal: true

require 'json'

module Hangman
  # Responsible for saving and loading game data
  class SaveManager
    attr_reader :save_exists

    def initialize(stuff, things)
      @save_exists = true if document(has_savedata)
      @data_snapshot = [stuff, things]
    end

    def save
      File.write('../saves/save.json') do |f|
        f.write(@data_snapshot.to_json)
      end
    end

    def load
      file = File.read('../saves/save.json', &:read)
      data_hash = JSON.parse(file)
    end
  end
end
