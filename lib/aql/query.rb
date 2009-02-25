module Aql
  class Query
    class Condition
      def initialize(left, opt, right)
        @left = left
        @opt = opt
        @right = right
      end
      
      def to_sql
        "#{@left} #{@opt} #{@right.inspect}"
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