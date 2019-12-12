# frozen_string_literal: true

class Transaction
  @chase_header_lines = 16

  class << self

    def chase(row)
      new row['Description'],
          :credit,
          Date._strptime(row['Transaction date'], '%b %d, %Y'),
          row['Description'],
          row['Amount'].gsub('$', '').to_f
    end

    def chase_create_header(lines)
      lines[15].strip.split(/\s\s+/)
    end

    def chase_create_row(line)
      line.strip.split(/\s\s+/)
    end

    def chase_included_rows(row)
      row.size == 4 && (row['Amount'] || '').include?('$')
    end
  end
end