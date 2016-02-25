# Dir.glob('./app/models/*.rb') { |file| require file }

class SnacksController < Puffs::ControllerBase
  def index
    @snacks = Snack.all
    render :index
  end
end
