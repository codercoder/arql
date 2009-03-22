module Arql
  class ColumnInvalid < StandardError
  end

  class Query
    class Column
      def self.create(model, name)
        column_name, joins = if model.column_names.include?(name)
          [name]
        elsif reflection = model.reflections[name.to_sym]
          if reflection.klass.arql_id
            ["#{reflection.klass.table_name}.#{reflection.klass.arql_id}", name.to_sym]
          else
            [reflection.primary_key_name]
          end
        else
          raise ColumnInvalid, "Couldn't figure out what's means #{name.inspect} for #{model.inspect}."
        end
        OpenStruct.new(:to_sql => column_name, :joins => joins)
      end
    end

    class Condition
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
          value.inspect
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
