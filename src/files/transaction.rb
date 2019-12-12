# frozen_string_literal: true

require_relative 'file_parser'

Dir['./transaction/*.rb'].each { |file| require file }

class Transaction
  attr_reader :name
  attr_reader :type
  attr_reader :date
  attr_reader :description
  attr_reader :amount

  def initialize(name, type, date, description, amount)
    @name = name
    @type = type
    @date = date
    @description = description
    @amount = amount
  end

  class << self

    def file_parser(prefix)
      header = create_header prefix
      header_lines = header_lines prefix
      adapter = method(prefix)
      create_row = create_row prefix
      included_rows = included_rows prefix
      FileParser.new header, header_lines, adapter, create_row, included_rows
    end

    private

    def header_lines(prefix)
      instance_variable_get("@#{prefix}_header_lines") || 0
    end

    def create_header(prefix)
      method_or_nil("#{prefix}_create_header") || ->(lines) { lines.first }
    end

    def create_row(prefix)
      method_or_nil("#{prefix}_create_row") || ->(e) { e.itself }
    end

    def included_rows(prefix)
      method_or_nil("#{prefix}_included_rows") || ->(_) { true }
    end

    def method_or_nil(method_name)
      method_sym = method_name.to_sym
      method method_sym if methods.include? method_sym
    end
  end
end

def transaction_type(type)
  case type.upcase
  when 'DEBIT'
    :debit
  when 'CREDIT'
    :credit
  else
    :unknown
  end
end
