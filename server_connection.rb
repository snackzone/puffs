require 'rack'
require './db/open_connection.rb'
require './config/router.rb'
require 'byebug'

router = Router.new
router.draw do
  get Regexp.new("^/cats/new$"), CatsController, :new
  post Regexp.new("^/cats/create$"), CatsController, :create
  get Regexp.new("^/cats$"), CatsController, :index
  get Regexp.new("^/cats/(?<cat_id>\\d+)/statuses$"), StatusesController, :index
  get Regexp.new("^/cats/(?<cat_id>\\d+)$"), CatsController, :show
end

app = Proc.new do |env|
  req = Rack::Request.new(env)
  res = Rack::Response.new
  router.run(req, res)
  res.finish
end

Rack::Server.start(
 app: app,
 Port: 3000
)
