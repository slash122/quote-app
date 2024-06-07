# frozen_string_literal: true
require_relative 'db_manager'
require_relative 'console_view'

module QuotationApp
  class Controller

    def self.run_app
      db_manager = DBManager.instance
      loop do
        input_hash = {
          'a' => 'Add a quote',
          'b' => 'View quotes on page (5 quotes per page)',
          'c' => 'Quote by author id',
          'd' => 'Delete quote by id',
          'q' => 'Quit'
        }
        input = ConsoleView.get_keyboard_input(input_hash)

        case input
        when 'a'
          quote = ConsoleView.get_string_input("Enter the quote:")
          author = ConsoleView.get_string_input("Enter the author:")
          db_manager.add_quote_and_author quote, author
        when 'b'
          page = ConsoleView.get_int_input("Enter the page number:")
          records = db_manager.get_quotes_on_page page
          ConsoleView.display_quotes records
        when 'c'
          author_id = ConsoleView.get_int_input("Enter author id:")
          records = db_manager.get_quotes_by_author author_id
          ConsoleView.display_quotes records
        when 'd'
          quote_id = ConsoleView.get_int_input("Enter quote id:")
          db_manager.delete_quote quote_id
        else
          break
        end

      end
    end


  end
end
