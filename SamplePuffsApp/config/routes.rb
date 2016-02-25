ROUTER = Router.new
ROUTER.draw do
  #Some sample routes:

  get Regexp.new("^/posts$"), PostsController, :index
  post Regexp.new("^/posts/create$"), PostsController, :create
  post Regexp.new("^/posts/destroy$"), PostsController, :destroy

  get Regexp.new("^/users$"), UsersController, :index

  get Regexp.new("^/users/(?<user_id>\\d+)$"), UsersController, :show

  # get Regexp.new("^/cats/new$"), CatsController, :new
  # post Regexp.new("^/cats/create$"), CatsController, :create
  # get Regexp.new("^/cats$"), CatsController, :index
  # get Regexp.new("^/cats/(?<cat_id>\\d+)$"), CatsController, :show
end
