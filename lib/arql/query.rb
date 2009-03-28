module Arql
  class ColumnInvalid < StandardError
  end

  module SqlHeler
    def quote(name, column=nil)
      ActiveRecord::Base.connection.quote(name.to_s, column)
    end

    def quote_table_name(name)
      ActiveRecord::Base.connection.quote_table_name(name.to_s)
    end

    def quote_column_name(name)
      ActiveRecord::Base.connection.quote_column_name(name.to_s)
    end

    def quote_name(table_name, column_name)
      "#{quote_table_name(table_name)}.#{quote_column_name(column_name)}"
    end
  end

  class Query
    class Column
      class ColumnFactory
        include SqlHeler
        def initialize(model, name)
          @model = model
          @name = name
        end

        def create_column
          column_name, joins = if @model.column_names.include?(@name)
            [quote_name(@model.table_name, @name)]
          elsif reflection = @model.reflections[@name.to_sym]
            if reflection.klass.arql_id
              column_name = reflection.klass.arql_id
              [quote_name(reflection.klass.table_name, column_name), reflection.name.to_sym]
            else
              [reflection.primary_key_name]
            end
          elsif reflection = reflection_of_specified_comparision_name_in_arql
            #specified comparision name in arql: project.name = 'arql'
            arql_id = @name.split('.').last
            [quote_name(reflection.klass.table_name, arql_id), reflection.name.to_sym]
          else
            raise column_invalid
          end
          OpenStruct.new(:to_sql => (column_name), :joins => joins)
        end

        private
        def reflection_of_specified_comparision_name_in_arql
          if @name =~ /.+\..+/
            reflection_name = @name.split('.').first
            @model.reflections[reflection_name.to_sym]
          end
        end

        def column_invalid
          ColumnInvalid.new "Couldn't figure out what's means #{@name.inspect} for #{@model.inspect}."
        end
      end

      def self.create(model, name)
        ColumnFactory.new(model, name).create_column
      end
    end

    class Condition
      include SqlHeler
      def initialize(left, opt, right)
        @left = left
        @opt = opt
        @right = right
      end
      
      def to_sql
        "#{@left.to_sql} #{@opt} #{primitive_types_to_sql(@right)}"
      end

      private
      def primitive_types_to_sql(value)
        case value
        when String
          quote(value)
        when Numeric
          value
        end
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
