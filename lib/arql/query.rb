module Arql
  class ColumnInvalid < StandardError
  end

  class Query
    class Condition
      def initialize(left, opt, right)
        @left = left
        @opt = opt
        @right = right
      end
      
      def to_sql(model)
        column_name = if model.column_names.include?(@left)
          @left
        elsif reflection = model.reflections[@left.to_sym]
          reflection.primary_key_name
        else
          raise ColumnInvalid, "Couldn't figure out what's means #{@left.inspect}."
        end
        "#{column_name} #{@opt} #{@right.inspect}"
      end
    end
    
    class Or
      def initialize(left, right)
        @left = left
        @right = right
      end
      
      def to_sql(model)
        @left.to_sql(model) + " or " +  @right.to_sql(model)
      end
    end
    
    class And
      def initialize(left, right)
        @left = left
        @right = right
      end
      
      def to_sql(model)
        @left.to_sql(model) + " and " + @right.to_sql(model)
      end
    end
    
    def initialize(options)
      @condition = options[:condition]
    end

    def find_options(model)
      {:conditions => @condition.to_sql(model)}
    end
  end
end
