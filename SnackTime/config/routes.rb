ROUTER = Router.new
ROUTER.draw do
  #Some sample routes:

  # get Regexp.new("^/cats/new$"), CatsController, :new
  get Regexp.new("^/snacks$"), SnacksController, :index
  # post Regexp.new("^/cats/create$"), CatsController, :create
  # get Regexp.new("^/cats$"), CatsController, :index
  # get Regexp.new("^/cats/(?<cat_id>\\d+)$"), CatsController, :show
end
