# frozen_string_literal: true

class Transaction
  @usbank_header_lines = 1

  def self.usbank(row)
    Transaction.new row['Name'],
                    transaction_type(row['Transaction']),
                    Date._strptime(row['Date'], '%m/%d/%Y'),
                    row['Memo'], row['Amount'].to_f
  end
end