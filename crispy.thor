class Generate < Thor
  desc "model <name>", "generate a model with the specified name."
  def model(name)
    m_name = name.capitalize

    #writes model file
    File.open("./app/models/#{m_name.downcase}.rb", "w") do |f|
      f.write("require_relative '../../lib/sql_object/sql_object'\n\n")
      f.write("class #{m_name} < SQLObject\n\n")
      f.write("end\n")
      f.write("#{m_name}.finalize!")
    end
    migration("Create#{m_name}")
    puts "#{m_name} model created"
  end

  desc "controller <name>", "generate a controller with the specified name."
  def controller(name)
    c_name = name.capitalize

    #Writes controller file
    File.open("./app/controllers/#{c_name.downcase}.rb", "w") do |f|
      f.write("require_relative '../../lib/controller_base'\n")
      f.write("project_root = File.dirname(File.absolute_path(__FILE__))\n")
      f.write("Dir.glob(project_root + '/../models/*.rb') { |file| require file }\n\n")

      f.write("class #{c_name}Controller < ControllerBase\n\n")
      f.write("end")
    end

    #creates empty views directory
    Dir.mkdir "./app/views/#{c_name.downcase}"
    puts "#{c_name} controller created"
  end

  desc "migration <name>", "generates an empty sql file with a filename of the specified <name> appended to a timestamp"
  def migration(name)
    #create a timestamp
    ts = Time.now.to_s.split(" ").take(2).join("").split("").map{|el| el.to_i}.join
    require 'active_support/inflector'
    filename = "#{ts}__#{name.underscore.downcase}"

    #create the migration file
    File.open("./db/migrate/#{filename}.sql", "w")
  end
end

class Crispy < Thor
  desc "generate", "subcommand used for generating models and controllers"
  subcommand 'generate', Generate

  desc "g", "alias of generate subcommand"
  subcommand 'g', Generate

  desc 'server', 'starts the crispy server'
  def server
    require_relative 'lib/server_connection'
    ServerConnection.start
  end
end

class Db < Thor
  desc "create", "creates the DB"
  def create
    require_relative 'lib/db_connection'
    DBConnection.reset
    puts 'db created!'
  end

  desc "migrate", "runs pending migrations"
  def migrate
    require_relative 'lib/db_connection'
    DBConnection.migrate
  end

  desc "seed", "seeds the DB"
  def seed
    require_relative 'db/seeds'
    Seed.populate
    puts 'db seeded!'
  end

  desc "reset", "resets the DB and seeds it"
  def reset
    create
    migrate
    seed
    puts 'db reset!'
  end
end

class Rake < Thor
  desc "example", "an example task"
  def example
    puts "I'm a thor task!"
  end
end
