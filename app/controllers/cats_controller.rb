require_relative '../../lib/controller_base'
project_root = File.dirname(File.absolute_path(__FILE__))
Dir.glob(project_root + '/../models/*.rb') { |file| require file }

class CatsController < ControllerBase
  def index
    @cats = Cat.all
    render :index
  end

  def show
    @cat = Cat.find(Integer(params['cat_id']))
    render :show
  end

  def new
    render :new
  end

  def create
    @cat = Cat.new
    @cat.name = params['cat']['name']
    @cat.save
    render :show
  end
end
