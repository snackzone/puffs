class Generate < Thor
  desc "model <name>", "generate a model with the specified name."
  def model(name)
    puts "creating #{name.capitalize} model"
  end

  desc "controller <name>", "generate a controller with the specified name."
  def controller(name)
    puts "creating the #{name.capitalize}s controller"
  end
end

class Crispy < Thor
  desc "generate", "subcommand used for generating models and controllers"
  subcommand 'generate', Generate

  desc "g", "alias of generate subcommand"
  subcommand 'g', Generate

  desc 'server', 'starts the crispy server'
  def server
    require_relative 'server_connection'
  end
end

class Db < Thor
  desc "create", "creates the DB"
  def create
    require_relative 'lib/db_connection'
    DBConnection.reset
    puts 'db created!'
  end

  desc "seed", "seeds the DB"
  def seed
    require_relative 'db/seed'
    Seed.populate
    puts 'db seeded!'
  end

  desc "reset", "resets the DB and seeds it"
  def reset
    create
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
