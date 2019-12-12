class FileParser

  attr_reader :header_lines

  def initialize(header, header_lines, adapter, create_row, included_rows)
    @header = header
    @header_lines = header_lines
    @adapter = adapter
    @create_row = create_row
    @included_rows = included_rows
  end

  def adapter(row)
    @adapter.call row
  end

  def create_row(line)
    @create_row.call line
  end

  def included_rows(row)
    @included_rows.call row
  end

  def header(lines)
    @header.call lines
  end

  def convert_lines_to_transactions(lines)
    header = header lines
    lines.drop(header_lines).map do |line|
      row = create_row line
      Hash[header.zip row]
    end.select(&method(:included_rows)).map(&method(:adapter))
  end
end