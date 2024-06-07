# frozen_string_literal: true
require_relative '../lib/db_manager'
require 'nokogiri'
require 'uri'
require 'net/http'

start_time = Time.now

db_manager = QuotationApp::DBManager.instance
db_manager.open_conn
db_manager.prepare_to_add_qa

(1..10).each { |page_num|
  url = URI.parse("https://www.goodreads.com/quotes?page=#{page_num}")
  response = Net::HTTP.get_response(url)
  doc = Nokogiri::XML(response.body)
  doc.xpath("//div[@class='quoteText']").each do |quote|
    author = quote.xpath("span/text()")[0].text.strip

    author = author.chop if author[-1] == ','
    quote_text = quote.text.lines[1].gsub('<br/>', '').lstrip.chomp

    db_manager.bulk_add_quote_and_author quote_text, author

    # For testing
    # db_manager.add_quote_and_author quote_text, author
  end
}

db_manager.close_conn

end_time = Time.now
puts "Time taken: #{end_time - start_time} seconds"