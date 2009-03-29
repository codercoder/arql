module Arql
  class ColumnInvalid < StandardError
  end

  class OperatorInvalid < StandardError
  end

  module SqlHeler
    def quote(name, column=nil)
      ActiveRecord::Base.connection.quote(name, column)
    end

    def quote_table_name(name)
      ActiveRecord::Base.connection.quote_table_name(name)
    end

    def quote_column_name(name)
      ActiveRecord::Base.connection.quote_column_name(name)
    end

    def quote_name(table_name, column_name)
      "#{quote_table_name(table_name)}.#{quote_column_name(column_name)}"
    end
  end

  class Query
    class Column
      include SqlHeler

      def self.create(model, arql_name)
        Column.new(model, arql_name)
      end

      attr_reader :join, :arql_name

      def initialize(model, arql_name)
        @model = model
        @arql_name = arql_name
        init_column_model_and_name
      end

      def to_sql
        quote_name(@column_model.table_name, @column_name)
      end

      def quote_value(value)
        origin_column = @column_model.columns_hash[@column_name]
        quote(value, origin_column)
      end

      private
      def init_column_model_and_name
        if origin_column = @model.columns_hash[@arql_name]
          @column_name = origin_column.name
          @column_model = @model
        elsif ref = @model.reflections[@arql_name.to_sym]
          if ref.klass.arql_id
            @column_model = ref.klass
            @column_name = @column_model.arql_id
            @join = ref.name.to_sym
          else
            @column_model = @model
            @column_name = ref.primary_key_name
          end
        elsif ref = reflection_of_specified_comparision_name_in_arql
          #specified comparision name in arql: project.name = 'arql'
          @column_model = ref.klass
          @column_name = @arql_name.split('.').last
          @join = ref.name.to_sym
        else
          raise column_invalid
        end
      end

      def column_invalid
        ColumnInvalid.new "Couldn't figure out what's means #{@arql_name.inspect} for #{@model.inspect}."
      end

      def reflection_of_specified_comparision_name_in_arql
        if @arql_name =~ /.+\..+/
          reflection_name = @arql_name.split('.').first
          @model.reflections[reflection_name.to_sym]
        end
      end
    end

    class Operator
      def initialize(opt)
        @opt = opt
      end

      def expression(left, right)
        Expression.new(left, self, right)
      end

      def to_sql(left, right)
        raise OperatorInvalid, "Unknown what's means: #{self} nil" if right.nil?
        "#{@opt} #{left.quote_value(right)}"
      end

      def to_s
        @opt
      end
    end

    class Equal < Operator
      include Singleton

      def initialize
        super('=')
      end

      def expression(left, right)
        if right === false
          Or.new(super, Expression.new(left, self, nil))
        else
          super
        end
      end

      def to_sql(left, right)
        right.nil? ? 'IS NULL' : super
      end
    end

    class Unequal < Operator
      include Singleton

      def initialize
        super('!=')
      end

      def expression(left, right)
        if right.nil?
          super
        else
          Or.new(super, Expression.new(left, Equal.instance, nil))
        end
      end

      def to_sql(left, right)
        right.nil? ? 'IS NOT NULL' : super
      end
    end

    class Condition
      def initialize(left, opt, right)
        @left = left
        @opt = opt
        @right = right
      end

      def to_sql
        @opt.expression(@left, @right).to_sql
      end
    end

    class Expression
      def initialize(left, opt, right)
        @left = left
        @opt = opt
        @right = right
      end

      def to_s
        "#{@left.arql_name} #{@opt} #{@right}"
      end

      def to_sql
        "#{@left.to_sql} #{@opt.to_sql(@left, @right)}"
      end
    end

    class Or
      def initialize(left, right)
        @left = left
        @right = right
      end
      
      def to_sql
        @left.to_sql + " or " +  @right.to_sql
      end
    end

    class And
      def initialize(left, right)
        @left = left
        @right = right
      end
      
      def to_sql
        @left.to_sql + " and " + @right.to_sql
      end
    end

    def initialize(options)
      @condition = options[:condition]
      @joins = options[:joins]
    end

    def find_options
      returning({:conditions => @condition.to_sql}) do |options|
        options.merge! :joins => @joins unless @joins.blank?
      end
    end
  end
end
