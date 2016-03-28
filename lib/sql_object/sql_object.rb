require 'byebug'
require 'active_support/inflector'
require_relative '../../lib/db_connection'
require_relative 'associatable'
require_relative '../relation'
require_relative 'searchable'

module Puffs
  # Base Model class for Puffs Orm.
  class SQLObject
    extend Associatable
    extend Searchable
    
    def self.columns
      Puffs::DBConnection.columns(table_name)
    end

    def self.define_singleton_method_by_proc(obj, name, block)
      metaclass = class << obj; self; end
      metaclass.send(:define_method, name, block)
    end

    def self.destroy_all!
      all.each(&:destroy!)
    end

    def self.finalize!
      columns.each do |column|
        define_method(column) do
          attributes[column]
        end

        define_method("#{column}=") do |new_value|
          attributes[column] = new_value
        end
      end
    end

    def self.has_association?(association)
      assoc_options.keys.include?(association)
    end

    def self.parse_all(results)
      relation = Puffs::SQLRelation.new(klass: self, loaded: true)
      results.each do |result|
        relation << new(result)
      end

      relation
    end

    def self.table_name=(table_name)
      @table_name = table_name
    end

    def self.table_name
      @table_name ||= to_s.downcase.tableize
    end

    def initialize(params = {})
      params.each do |attr_name, value|
        unless self.class.columns.include?(attr_name.to_sym)
          raise "unknown attribute '#{attr_name}'"
        end

        send("#{attr_name}=", value)
      end
    end

    def attributes
      @attributes ||= {}
    end

    def attribute_values
      self.class.columns.map do |column|
        send(column)
      end
    end

    def destroy!
      if self.class.find(id)
        Puffs::DBConnection.execute(<<-SQL)
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
      column_values = columns.map { |attr_name| send(attr_name) }
      column_names = columns.join(', ')
      bind_params = (1..columns.length).map { |n| "$#{n}" }.join(', ')
      result = Puffs::DBConnection.execute(<<-SQL, column_values)
        INSERT INTO
          #{self.class.table_name} (#{column_names})
        VALUES
          (#{bind_params})
          RETURNING id;
      SQL
      self.id = result.first['id']
      self
    end

    def save
      self.class.find(id) ? update : insert
    end

    def update
      set_line = self.class.columns.map do |column|
        "#{column} = \'#{send(column)}\'"
      end.join(', ')

      Puffs::DBConnection.execute(<<-SQL)
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
end
