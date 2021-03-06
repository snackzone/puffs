class PostsController < Puffs::ControllerBase
  def index
    @posts = Post.all.includes(:user).includes(:comments).order(id: :desc).load
  end

  def create
    @post = Post.new(body: params['post']['body'], author_id: 1).save
    redirect_to ('/posts')
  end

  def destroy
    @post = Post.find(params['post_id'])
    @post.destroy!
    redirect_to ('/posts')
  end
end
