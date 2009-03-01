module Arql
  class ColumnInvalid < StandardError
  end

  class Query
    class Column
      def initialize(model, name)
        @model = model
        @name = name
      end

      def to_sql
        column_name = if @model.column_names.include?(@name)
          @name
        elsif reflection = @model.reflections[@name.to_sym]
          reflection.primary_key_name
        else
          raise ColumnInvalid, "Couldn't figure out what's means #{@name.inspect}."
        end
      end
    end

    class Condition
      def initialize(left, opt, right)
        @left = left
        @opt = opt
        @right = right
      end
      
      def to_sql
        "#{@left.to_sql} #{@opt} #{@right.inspect}"
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
    end

    def find_options
      {:conditions => @condition.to_sql}
    end
  end
end
