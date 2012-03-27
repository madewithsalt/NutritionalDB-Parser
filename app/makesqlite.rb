require_relative 'formats'
require 'sqlite3'

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

    #Instance of our formats class, which defines the table columns.
    @format = Formats.new

    # Create or open our database.
    @db = SQLite3::Database.new("../output/nutritional_db.db")

    #fire in the hole!
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
    # get the corresponding data hash object symbol,
    # which should be named after the DB file in lowercase.
    format = @format.get_format_hash
    file_base_name =  File.basename(file_name, File.extname(file_name))
    format_sym_name = file_base_name.to_s.downcase
    format_array =  format.fetch(format_sym_name.to_sym)

    #TODO: Make output dir configurable.
    target_dir = '../output/'

    puts "Creating file database in #{target_dir}..."

    #Apply format array to table, where each item in array is a fieldname
    db_columns = ""
    format_array.each {|field|
      if field == format_array.last
        db_columns= db_columns + "#{field} TEXT"
      else
        db_columns= db_columns + "#{field} TEXT, "
      end
    }


    #Make our table with the DB filename as our table name.
    puts "create table #{file_base_name} with columns: #{format_array}"
    @db.execute("drop table if exists #{file_base_name}")
    @db.execute("create table #{file_base_name} (#{db_columns})")

    #Read the text file and push the data into the SQLite DB.
    puts "Saving file data to #{file_base_name} ..."

    while (line = @source_file.gets)
      line = line.gsub(/~/, '')

      fields = line.split('^')
      if fields.count < format_array.count
        loop = format_array.count - fields.count
        puts "uneven field count by #{loop}"

        if loop.eql?(1)
          fields.unshift(" ")
        else
          loop.each {fields.unshift(" ")}
        end
      end
      entry_string = ""
      fields.each{|entry|
        #escape out any single ' for double ''
        entry_sub = entry.gsub(/'/, "''")
        #wrap every entry into single quotes
        entry_string += "'#{entry_sub}'"

        if entry != fields.last
          entry_string += ", "
        end
      }

      # Insert into the DB! -- log is there to catch any errors.
      puts "insert into #{file_base_name} values (#{entry_string}) "
      @db.execute("insert into #{file_base_name} values (#{entry_string}) ")


    end

  end
end

#TO USE: pass the parser file an argument. Currently assumes your file is in the "../src/" dir.
# TODO: Make the input and output locations more flexible.

parser = Parser.new(ARGV[0])
