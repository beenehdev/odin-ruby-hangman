# frozen_string_literal: true

module Hangman
  # Responsible for providing word list from file
  class Dictionary
    def initialize
      File.open('../data/google-10000-english-no-swears.txt', 'r') do |file|
        @list = file.readlines
                    .map(&:chomp)
                    .select { |word| word.length.between?(5, 12) }
      end
    end

    def random_word
      @list.sample.split
    end
  end
end
