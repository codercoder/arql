module Arql
  module Query
    class Base
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
end
