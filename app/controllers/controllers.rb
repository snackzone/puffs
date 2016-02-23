require_relative 'controller_base'
require_relative '../models/models'
require 'byebug'

class StatusesController < ControllerBase
  def index
    statuses = $statuses.select do |s|
      s[:cat_id] == Integer(params['cat_id'])
    end

    render_content(statuses.to_json, "application/json")
  end
end

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
    debugger
    @cat = Cat.new
    @cat.name = params['cat']['name']
    @cat.save
    render :show
  end
end
