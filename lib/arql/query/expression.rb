module Arql
  module Query

    class Expression
      def initialize(left, opt, right)
        @left = left
        @opt = opt
        @right = right
      end

      def to_sql(*args)
        @left.expression_sql(@opt, @right)
      end

      def expression_sql(opt, right)
        "#{self.to_sql} #{opt} #{right.to_sql}"
      end
    end

  end
end
