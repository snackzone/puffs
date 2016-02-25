class UsersController < Puffs::ControllerBase
  def show
    @user = User.find(params['user_id'])
    render :show
  end
end
