module Arql

  class OperatorInvalid < StandardError; end

  module Query
    class Operator
      def initialize(opt)
        @opt = opt
      end

      def expression(left, right)
        right.nil? ? nil_expression(left) : not_nil_expression(left, right)
      end

      protected
      def not_nil_expression(left, right)
        Expression.new(left, @opt, right)
      end

      def nil_expression(left)
        raise OperatorInvalid, "Unknown what's means: #{@opt} nil"
      end
    end

    class And < Operator
      include Singleton
      def initialize
        super('and')
      end
    end

    class Or < Operator
      include Singleton
      def initialize
        super('or')
      end
    end

    class Equal < Operator
      include Singleton

      def initialize
        super('=')
      end

      def not_nil_expression(left, right)
        if right === false
          Or.instance.expression(super, nil_expression(left))
        else
          super
        end
      end

      def nil_expression(left)
        Expression.new(left, 'IS', nil)
      end
    end

    class Unequal < Operator
      include Singleton

      def initialize
        super('!=')
      end

      def not_nil_expression(left, right)
        Or.instance.expression(super, Equal.instance.nil_expression(left))
      end

      def nil_expression(left)
        Expression.new(left, 'IS NOT', nil)
      end
    end
  end
end
