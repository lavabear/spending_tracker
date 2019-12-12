# frozen_string_literal: true

require_relative 'transaction.rb'

class FileHandler
  class << self
    def handle_file(filename)
      prefix = filename.split('/').first
      if filename.end_with? '.pdf'
        handle_pdf prefix, filename
      else
        handle_csv prefix, filename
      end
    end

    private

    def handle_csv(prefix, filename)
      if SUPPORTED_FILE_TYPES.include? prefix
        lines = open_csv filename, true

        file_parser = Transaction.file_parser prefix
        file_parser.convert_lines_to_transactions lines
      else
        unsupported prefix, filename
      end
    end

    def handle_pdf(prefix, filename)
      reader = PDF::Reader.new BASE_PATH + filename
      if SUPPORTED_FILE_TYPES.include? prefix
        reader.pages.map(&:text).flat_map do |content|
          pdf_to_transactions prefix, content
        end
      else
        unsupported prefix, filename
      end
    end

    def unsupported(prefix, filename)
      puts "Unsupported #{prefix} for #{filename}"
      []
    end

    SUPPORTED_FILE_TYPES = %w[usbank iccu chase].freeze

    def open_csv(filename, quoted)
      File.open(BASE_PATH + filename)
          .map { |line| quoted ? line[1..-3].split(/","/) : line }
    end

    def pdf_to_transactions(prefix, content)
      lines = content.split(/(\r|\n)+/).reject do |line|
        line.include?("\r") || line.include?("\n")
      end

      file_parser = Transaction.file_parser prefix
      file_parser.convert_lines_to_transactions lines
    end
  end
end
