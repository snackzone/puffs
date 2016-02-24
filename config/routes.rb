require_relative '../lib/router'

router = Router.new
router.draw do
  get Regexp.new("^/cats/new$"), CatsController, :new
  post Regexp.new("^/cats/create$"), CatsController, :create
  get Regexp.new("^/cats$"), CatsController, :index
  get Regexp.new("^/cats/(?<cat_id>\\d+)/statuses$"), StatusesController, :index
  get Regexp.new("^/cats/(?<cat_id>\\d+)$"), CatsController, :show
end
