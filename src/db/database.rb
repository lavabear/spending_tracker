# frozen_string_literal: true

SAVE_TRANSACTIONS = "
  INSERT INTO transactions (
    name,
    type,
    date,
    description,
    amount,
    filename
  ) VALUES (?, ?, ?, ?, ?, ?)
"

module Database
  class << self

    def sql_from_file(filename)
      File.open(filename).map { |line| line }.join("\n")
    end

    def create
      ## Create Database
      @db = SQLite3::Database.new "#{BASE_PATH}/summary.db"
      create_tables
    end

    def save_spending_file(file)
      file.contents.each do |transaction|
        rows = @db.execute SAVE_TRANSACTIONS, transaction.name,
                           transaction.type.to_s, transaction.date.to_s,
                           transaction.description, transaction.amount, file.filename
      end
    end

    private

    def create_tables
      rows = @db.execute sql_from_file('src/db/tables.sql')
    end
  end
end
