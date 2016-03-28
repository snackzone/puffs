# Search methods for Puffs::SQLObject
module Searchable
  RELATION_METHODS = [
    :limit, :includes, :where, :order
  ].freeze

  RELATION_METHODS.each do |method|
    define_method(method) do |arg|
      Puffs::SQLRelation.new(klass: self).send(method, arg)
    end
  end

  def all
    where({})
  end

  def count
    all.count
  end

  def find(id)
    where(id: id).first
  end

  def first
    all.limit(1).first
  end

  def last
    all.order(id: :desc).limit(1).first
  end
end
