require_relative '../relation'

# Search methods for Puffs::SQLObject
module Searchable
  RELATION_METHODS = [
    :limit, :includes, :where, :order
  ].freeze

  RELATION_METHODS.each do |method|
    define_singleton_method(method) do |arg|
      Puffs::SQLRelation.new(klass: self).send(method, arg)
    end
  end

  def self.all
    where({})
  end

  def self.count
    all.count
  end

  def self.find(id)
    where(id: id).first
  end

  def self.first
    all.limit(1).first
  end

  def self.last
    all.order(id: :desc).limit(1).first
  end
end
