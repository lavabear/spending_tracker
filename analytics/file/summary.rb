filename = file.filename
contents = file.contents

puts filename

summary = contents.group_by do |transaction|
  [transaction.date[:mon], transaction.type]
end

puts summary.map do |month_summary|
  month_entry = month_summary.first
  month = month_entry.first
  type = month_entry.last
  puts "#{type} - #{month}"
  puts month_summary.last.map do |transactions|
    transactions
  end
end