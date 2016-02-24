require 'pg'
require 'byebug'

PRINT_QUERIES = ENV['PRINT_QUERIES'] == 'true'
# why on Earth was '..' there??
# ROOT_FOLDER = File.join(File.dirname(__FILE__), '..')
ROOT_FOLDER = File.join(File.dirname(__FILE__))
CATS_SQL_FILE = File.join(ROOT_FOLDER, 'pgcats.sql')
CATS_DB_FILE = File.join(ROOT_FOLDER, 'cats.db')

class DBConnection
  # def self.open(db_file_name)
  #   @db = SQLite3::Database.new(db_file_name)
  #   @db.results_as_hash = true
  #   @db.type_translation = true
  #
  #   @db
  # end
  def self.open(db_file_name)
    @db = PG::Connection.new( :dbname => "cats", :port => 5432 )
  end

  def self.reset
    commands = [
      "dropdb cats",
      "createdb cats",
      "psql -d cats -a -f #{CATS_SQL_FILE}"
    ]

    commands.each { |command| `#{command}` }
    DBConnection.open(CATS_DB_FILE)
  end

  def self.instance
    reset if @db.nil?

    @db
  end

  def self.execute(*args)
    print_query(*args)
    instance.exec(*args)
  end

  def self.columns(table_name)
    cols = instance.exec(<<-SQL)
      SELECT
        attname
      FROM
        pg_attribute
      WHERE
        attrelid = '#{table_name}'::regclass AND
        attnum > 0 AND
        NOT attisdropped
    SQL

    cols.map { |col| col['attname'].to_sym }
  end

  private

  def self.print_query(query, *interpolation_args)
    return unless PRINT_QUERIES

    puts '--------------------'
    puts query
    unless interpolation_args.empty?
      puts "interpolate: #{interpolation_args.inspect}"
    end
    puts '--------------------'
  end
end
