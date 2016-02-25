module Puffs
  #enjoy puffs
end

require_relative "sql_object/sql_object"
require_relative "controller_base"

Dir.glob('./app/models/*.rb') {|file| require file}
Dir.glob('./app/controllers/*.rb') {|file| require file}

require './db/seeds'

require_relative 'db_connection'
require_relative 'router'
require_relative 'server_connection'
require_relative 'session'
