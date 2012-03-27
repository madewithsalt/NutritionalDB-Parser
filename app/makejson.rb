require_relative 'formats'
require 'json'

class Parser
  def initialize(target)
    @is_dir = File.directory?(target)

    if @is_dir == FALSE
      @file_root = '../src/'
      @file_name = File.basename(target)
    else
      @file_root = target
      @file_name = []
      Dir.entries(target).each{|file|
        if File.directory?(file) == FALSE
          @file_name.push(file)
        end
      }

    end

    @format = Formats.new

    get_file_data
  end

  def get_file_data
    if @is_dir
      @file_name.each{|file|
        @source_file = File.new(@file_root+file, 'r')
        sort_file_data(file)
      }
    else
      @source_file = File.new(@file_root+@file_name, 'r')
      sort_file_data (@file_name)
    end
  end

  def sort_file_data(file_name)
    format = @format.get_format_hash
    # get the corresponding data hash object symbol, which should be named after the DB file in lowercase.
    format_sym_name = File.basename(file_name, File.extname(file_name)).to_s.downcase
    format_array =  format.fetch(format_sym_name.to_sym)
    format_folder = File.basename(file_name, File.extname(file_name))
    target_dir = '../output/'+ format_folder

    if Dir.exist?(target_dir) == FALSE
      Dir.mkdir(target_dir, 0755)
    end

    puts "Sorting file data to folder #{format_folder}..."

    #TODO: Make test for format.has_key?(targetData.to_sym)
    counter = 0
    while (line = @source_file.gets)
      # CURRENTLY, This saves each line of the ASCII database into it's own file, inside a
      # Folder named after the original file. This is crappy and outputs a TON of files,
      # But appeared to be the best way to import the db into Mongo. Still a WIP.
      counter = counter+1
      entry_obj = {}
      line = line.gsub(/~/, '')
      fields = line.split('^')

      format_array.each do |name|
        format_inx = format_array.index(name)
        entry_obj[name.to_sym] = fields[format_inx]
      end

      entry_json = JSON.generate(entry_obj)
      save_file_data("../output/#{format_folder}/#{format_folder}_#{counter}.json", entry_json)
    end

  end
  def save_file_data(file_name, data_obj)
    puts "Saving file data to #{file_name}..."

    @new_file = File.open("#{file_name}", "w")
    @new_file.write(data_obj)
  end
end

#TO USE: pass the parser file an argument. Currently assumes your file is in the "../src/" dir.
# TODO: Make the input and output locations more flexible.
parser = Parser.new(ARGV[0])
