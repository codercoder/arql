module Arql
  module Query
    class Base
      def initialize(options)
        @condition = options[:condition]
        @order_by = options[:order_by]
        @joins = options[:joins].collect(&:join).flatten.compact
      end

      def find_options
        returning({}) do |options|
          options[:conditions] = @condition.to_sql if @condition
          options[:order] = @order_by.collect(&:quoted_full_name).join(',') if @order_by
          options[:joins] = @joins unless @joins.blank?
        end
      end
    end
  end
end
