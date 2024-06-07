require 'singleton'
require 'pg'

module QuotationApp
  class DBManager
    include Singleton

    def initialize
      @conn = nil
    end

    def open_conn
      if !@conn || @conn.finished?
        @conn = PG.connect(
        dbname: 'quotation_app_db',
        user: 'glib',
        password: 'password',
        host: 'localhost',
        port: 5432
        )
      end
    end

    def close_conn
      if @conn && !@conn.finished?
        @conn.close
      end
    end

    #prepare to add quote and author
    def prepare_to_add_qa
      sql = "CALL insert_author_and_quote($1, $2)"
      @conn.prepare("insert_qa", sql)
    end

    def add_quote_and_author(quote_str, author_name)
      open_conn
      prepare_to_add_qa
      values = [quote_str, author_name]
      @conn.exec_prepared("insert_qa", values)
      console_log("INSERT " + values.to_s)
      close_conn
    end

    # does not open and close connection, need to prepare statement before
    # with prepare_to_add_qa
    def bulk_add_quote_and_author(quote_str, author_name)
      @conn.exec_prepared("insert_qa", [quote_str, author_name])
    end

    def get_quotes_on_page(page)
      open_conn
      result = @conn.exec("SELECT q.id as qid, q.content, a.name, a.id FROM quotation q
          JOIN author a ON q.author_id = a.id WHERE q.id BETWEEN #{page * 5} AND #{(page + 1) * 5};")
      records = Array.new
      result.each do |row|
        records << [row['qid'], row['content'], row['name'], row['id']]
      end
      close_conn
      records
    end

    def get_quotes_by_author(author_id)
      open_conn
      result = @conn.exec("SELECT q.id as qid, q.content, a.name, a.id FROM quotation q
          JOIN author a ON q.author_id = a.id WHERE a.id = #{author_id};")
      records = Array.new
      result.each do |row|
        records << [row['qid'], row['content'], row['name'], row['id']]
      end
      close_conn
      records
    end

    def delete_quote(quote_id)
      open_conn
      @conn.exec("DELETE FROM quotation WHERE id = #{quote_id};")
      close_conn
    end

    private
    def console_log(str_to_log)
      puts '[' + Time.now.strftime("%Y-%m-%d %H:%M:%S") + '] ' + str_to_log
    end

  end
end
