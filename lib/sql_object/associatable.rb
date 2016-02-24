require 'active_support/inflector'

class AssocOptions
  attr_accessor(
    :foreign_key,
    :class_name,
    :primary_key
  )

  def model_class
    class_name.constantize
  end

  def table_name
    model_class.table_name
  end
end

class BelongsToOptions < AssocOptions
  def initialize(name, options = {})
    @primary_key = options[:primary_key] || :id
    @foreign_key = options[:foreign_key] || "#{name}_id".to_sym
    @class_name = options[:class_name] || name.to_s.capitalize
  end
end

class HasManyOptions < AssocOptions
  def initialize(name, self_class_name, options = {})
    @primary_key = options[:primary_key] || :id
    @foreign_key = options[:foreign_key] || "#{self_class_name.to_s.underscore}_id".to_sym
    @class_name = options[:class_name] || name.to_s.singularize.camelcase
  end
end

module Associatable
  def belongs_to(name, options = {})
    options = BelongsToOptions.new(name, options)
    assoc_options[name] = options

    define_method(name) do
      foreign_key_value = self.send(options.foreign_key)
      return nil if foreign_key_value.nil?

      options.model_class
             .where(options.primary_key => foreign_key_value)
             .first
    end
  end

  def has_many(name, options = {})
    options = HasManyOptions.new(name, self.to_s, options)
    assoc_options[name] = options

    define_method(name) do
      target_key_value = self.send(options.primary_key)
      return nil if target_key_value.nil?
      options.model_class
             .where(options.foreign_key => target_key_value)
             .to_a
    end
  end

  def assoc_options
    @assoc_options ||= {}
  end

  def has_one_through(name, through_name, source_name)
    through_options = assoc_options[through_name]

    define_method(name) do
      source_options =
        through_options.model_class.assoc_options[source_name]
      through_pk = through_options.primary_key
      key_val = self.send(through_options.foreign_key)

      source_options.model_class.includes(through_options.model_class)
                                .where(through_pk => key_val).first
    end
  end

  def has_many_through(name, through_name, source_name)
    through_options = assoc_options[through_name]
    define_method(name) do
      through_fk = through_options.foreign_key
      through_class = through_options.model_class
      key_val = self.send(through_options.primary_key)

      #2 queries, we could reduce to 1 by writing SQLRelation::join.
      through_class.where(through_fk => key_val)
                   .includes(source_name)
                   .load
                   .included_relations
                   .first
                   .to_a
    end
  end
end
