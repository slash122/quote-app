# frozen_string_literal: true
require 'singleton'

module QuotationApp
  class ConsoleView

    # key represents the input char
    def self.get_keyboard_input(input_hash)
      success = false
      until success
        input_hash.each do |key, input_option|
          puts "[#{key}] -- #{input_option}"
        end
        input = gets.chomp

        if input_hash.has_key?(input)
          return input
        end
      end
    end

    def self.get_int_input(input_msg)
      puts input_msg
      input = gets.chomp
      return input.to_i
    end

    def self.get_string_input(input_msg)
      puts input_msg
      return gets.chomp
    end

    def self.display_quotes(records) #2d array
      records.each do |record|
        puts "Id: #{record[0]}"
        puts "\"#{record[1]}\""
        puts "By: #{record[2]}, Id: #{record[3]}"
        puts "---------------------------"
      end
    end

  end
end
