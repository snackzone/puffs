require_relative '../../db/db_connection'
require_relative 'associatable'
require_relative '../relation'
require 'active_support/inflector'

class SQLObject
  extend Associatable

  RELATION_METHODS = [
    :limit, :includes, :where, :order
  ]

  RELATION_METHODS.each do |method|
    define_singleton_method(method) do |arg|
      SQLRelation.new(klass: self).send(method, arg)
    end
  end

  def self.all
    where({})
  end

  def self.columns
    @table ||= DBConnection.execute(<<-SQL)
      SELECT
        *
      FROM
        #{self.table_name} LIMIT 1;
      SQL
    @table.first.keys.map(&:to_sym)
  end

  def self.count
    all.count
  end

  def self.define_singleton_method_by_proc(obj, name, block)
    metaclass = class << obj; self; end
    metaclass.send(:define_method, name, block)
  end

  def self.destroy_all!
    self.all.each do |entry|
      entry.destroy!
    end
  end

  def self.finalize!
    self.columns.each do |column|
      define_method(column) do
        attributes[column]
      end

      define_method("#{column}=") do |new_value|
        attributes[column] = new_value
      end
    end
  end

  def self.find(id)
    where(id: id).first
  end

  def self.first
    all.limit(1).first
  end

  def self.has_association?(association)
    assoc_options.keys.include?(association)
  end

  def self.last
    all.order(id: :desc).limit(1).first
  end

  def self.parse_all(results)
    relation = SQLRelation.new(klass: self, loaded: true)
    results.each do |result|
      relation << self.new(result)
    end

    relation
  end

  def self.table_name=(table_name)
    @table_name = table_name
  end

  def self.table_name
    @table_name ||= self.to_s.downcase.tableize
  end

  def initialize(params = {})
    params.each do |attr_name, value|
      unless self.class.columns.include?(attr_name.to_sym)
        raise "unknown attribute '#{attr_name}'"
      end

      self.send("#{attr_name}=", value)
    end
  end

  def attributes
    @attributes ||= {}
  end

  def attribute_values
    self.class.columns.map do |column|
      self.send(column)
    end
  end

  def destroy!
    if self.class.find(id)
      DBConnection.execute(<<-SQL)
        DELETE
        FROM
          #{self.class.table_name}
        WHERE
          id = #{id}
      SQL
      return self
    end
  end

  def insert
    columns = self.class.columns.reject { |col| col == :id }
    column_values = columns.map {|attr_name| send(attr_name)}
    column_names = columns.join(", ")
    bind_params = (1..columns.length).map {|n| "$#{n}"}.join(", ")
    result = DBConnection.execute(<<-SQL, column_values)
      INSERT INTO
        #{self.class.table_name} (#{column_names})
      VALUES
        (#{bind_params})
        RETURNING id;
    SQL
    # self.id = DBConnection.last_insert_row_id
    self.id = result.first['id']
    self
  end

  # def insert
  #   cols = columns.reject { |col| col == :id }
  #   col_values = cols.map { |attr_name| send(attr_name) }
  #   col_names = cols.join(", ")
  #   question_marks = (["?"] * cols.size).join(", ")
  #
  #   result = DBConnection.execute(<<-SQL, col_values)
  #     INSERT INTO
  #       #{table_name} (#{col_names})
  #     VALUES
  #       (#{question_marks})
  #     RETURNING id
  #   SQL
  #
  #   self.id = result.first['id']
  #   # DBConnection.last_insert_row_id
  #
  #   true
  # end

  def save
    self.class.find(id) ? update : insert
  end

  def update
    set_line = self.class.columns.map do |column|
      #bobby tables says hi!
      "#{column} = \'#{self.send(column)}\'"
    end.join(", ")

    DBConnection.execute(<<-SQL)
      UPDATE
        #{self.class.table_name}
      SET
        #{set_line}
      WHERE
        id = #{id}
    SQL
    self
  end
end
