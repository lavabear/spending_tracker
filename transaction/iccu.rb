# frozen_string_literal: true

class Transaction
  @iccu_header_lines = 1

  def self.iccu(row)
    Transaction.new row['Transaction ID'],
                    transaction_type(row['Transaction Type']),
                    Date._strptime(row['Posting Date'], '%m/%d/%Y'),
                    row['Description'], row['Amount'].to_f
  end
end