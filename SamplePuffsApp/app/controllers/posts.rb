class PostsController < Puffs::ControllerBase
  def index
    @posts = Post.all
  end
end
