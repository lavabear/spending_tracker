# frozen_string_literal: true

require 'date'
require 'json'

require 'async'
require 'pdf-reader'
require 'sqlite3'

require_relative 'src/db/database'
require_relative 'src/files/file_handler'
require_relative 'src/models/spending_file'

BASE_PATH = ENV['BASE_PATH'] || Dir.pwd

USAGE = 'ruby app.rb [<filename|csv|pdf>]'

puts "usage: #{USAGE}" if ARGV.empty?

Database.create

analyzed = []

ARGV.each do |filename|
  Async do
    contents = FileHandler.handle_file(filename)
    file = SpendingFile.new filename, contents
    Database.save_spending_file file
    file.analyze
    analyzed.push file
  end
end

Async do
  loop do
    break if analyzed.size == ARGV.size

    sleep 1_000
  end

  puts 'summary'
end.wait