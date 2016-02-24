require 'pg'
require 'byebug'

PRINT_QUERIES = ENV['PRINT_QUERIES'] == 'true'
ROOT_FOLDER = File.join(File.dirname(__FILE__))
CATS_SQL_FILE = File.join(ROOT_FOLDER, '../db/migrations/pgcats.sql')

class DBConnection
  def self.open
    @db = PG::Connection.new( :dbname => "cats", :port => 5432 )
  end

  def self.reset
    commands = [
      "dropdb cats",
      "createdb cats",
      "psql -d cats -a -f #{CATS_SQL_FILE}"
    ]

    commands.each { |command| `#{command}` }
    DBConnection.open
  end

  def self.instance
    self.open if @db.nil?

    @db
  end

  def self.execute(*args)
    print_query(*args)
    instance.exec(*args)
  end

  def self.columns(table_name)
    columns = instance.exec(<<-SQL)
      SELECT
        attname
      FROM
        pg_attribute
      WHERE
        attrelid = '#{table_name}'::regclass AND
        attnum > 0 AND
        NOT attisdropped
    SQL

    columns.map { |col| col['attname'].to_sym }
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
