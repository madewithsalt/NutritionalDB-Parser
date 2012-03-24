# TODO: Make this test not suck!

require_relative "../app/formats"
require_relative "../app/parser"
require "json"
require "pp"

def test_read_json_file(file_name)
  file =  File.read("../output/" + file_name)
  json_file = JSON.parse(file)
  first_entry = json_file.at(0)
  first_entry_first_value = first_entry.fetch("DataSrc_ID")

  puts "Testing validity of JSON file: #{file_name} ..."
  pp "Found #{json_file.count} entries in file."
  pp "First entry has #{first_entry.length} name/value pairs."
  pp "The first entry's DataSrc_ID is #{first_entry_first_value}.'"

end


test_read_json_file(file)