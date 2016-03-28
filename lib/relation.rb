module Puffs
  # Queries made through Puffs::SQLObject return instance of SQLRelation
  class SQLRelation
    def self.build_association(base, included, method_name)
      base.included_relations << included

      assoc_options = base.klass.assoc_options[method_name]
      has_many = assoc_options.class == HasManyOptions

      if has_many
        i_send = assoc_options.foreign_key
        b_send = assoc_options.primary_key
      else
        i_send = assoc_options.primary_key
        b_send = assoc_options.foreign_key
      end

      match = proc do
        selection = included.select do |i_sql_obj|
          i_sql_obj.send(i_send) == send(b_send)
        end

        associated = has_many ? selection : selection.first

        # After we find our values iteratively, we overwrite the method again
        # to the result values to reduce future lookup time to O(1).
        new_match = proc { associated }
        Puffs::SQLObject.define_singleton_method_by_proc(
          self, method_name, new_match)

        associated
      end

      # We overwrite the association method for each SQLObject in the
      # collection so that it points to our cached relation and
      # doesn't fire a query.
      base.collection.each do |b_sql_obj|
        Puffs::SQLObject.define_singleton_method_by_proc(
          b_sql_obj, method_name, match)
      end
    end

    attr_reader :klass, :collection, :loaded, :sql_count, :sql_limit
    attr_accessor :included_relations

    def initialize(options)
      defaults =
        {
          loaded: false,
          collection: []
        }

      merged_options = defaults.merge(options)

      @klass      = options[:klass]
      @collection = merged_options[:collection]
      @loaded     = merged_options[:loaded]
    end

    def <<(item)
      @collection << item if item.class == klass
    end

    def count
      @sql_count = true
      load
    end

    def included_relations
      @included_relations ||= []
    end

    def includes(klass)
      includes_params << klass
      self
    end

    def includes_params
      @includes_params ||= []
    end

    def limit(n)
      @sql_limit = n
      self
    end

    def load
      unless loaded
        puts "LOADING #{table_name}"
        results = Puffs::DBConnection.execute(<<-SQL, sql_params[:values])
          SELECT
            #{sql_count ? 'COUNT(*)' : table_name.to_s + '.*'}
          FROM
            #{table_name}
          #{sql_params[:where]}
            #{sql_params[:params]}
          #{order_by_string}
          #{"LIMIT #{sql_limit}" if sql_limit};
        SQL

        results = sql_count ? results.first.values.first : parse_all(results)
      end

      results ||= self
      results = load_includes(results) unless includes_params.empty?
      results
    end

    def load_includes(relation)
      includes_params.each do |param|
        next unless relation.klass.has_association?(param)

        puts "LOADING #{param}"
        assoc = klass.assoc_options[param]
        f_k = assoc.foreign_key
        p_k = assoc.primary_key
        includes_table = assoc.table_name.to_s
        in_ids = relation.collection.map(&:id).join(', ')
        has_many = assoc.class == HasManyOptions

        results = Puffs::DBConnection.execute(<<-SQL)
          SELECT
            #{includes_table}.*
          FROM
            #{includes_table}
          WHERE
            #{includes_table}.#{has_many ? f_k : p_k}
          IN
            (#{in_ids});
        SQL
        included = assoc.model_class.parse_all(results)
        SQLRelation.build_association(relation, included, param)
      end

      relation
    end

    def method_missing(method, *args, &block)
      to_a.send(method, *args, &block)
    end

    def order(params)
      if params.is_a?(Hash)
        order_params_hash.merge!(params)
      else
        order_params_hash[params] = :asc
      end
      self
    end

    def order_params_hash
      @order_params_hash ||= {}
    end

    def order_by_string
      hash_string = order_params_hash.map do |column, asc_desc|
        "#{column} #{asc_desc.to_s.upcase}"
      end.join(', ')

      hash_string.empty? ? '' : "ORDER BY #{hash_string}"
    end

    def parse_all(attributes)
      klass.parse_all(attributes)
           .where(where_params_hash)
           .includes(includes_params)
    end

    def sql_params
      params = []
      values = []

      i = 1
      where_params_hash.map do |attribute, value|
        params << "#{attribute} = $#{i}"
        values << value
        i += 1
      end

      { params: params.join(' AND '),
        where: params.empty? ? nil : 'WHERE',
        values: values }
    end

    def table_name
      klass.table_name
    end

    def to_a
      load.collection
    end

    def where_params_hash
      @where_params_hash ||= {}
    end

    def where(params)
      where_params_hash.merge!(params)
      self
    end
  end
end
