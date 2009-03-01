require 'arql/parser'
module Arql
  class WhyNotArql < StandardError; end

  module ActiveRecordExt
    def self.included(base)
      base.extend(ClassMethods)
      class << base
        alias_method_chain :find, :arql
      end
    end

    module ClassMethods
      def find_with_arql(*args)
        options = args.extract_options!
        if arql = options.delete(:arql)
          raise WhyNotArql, 'Why not use :arql option to replace :conditions option?' if options[:conditions]
          arql_options = Parser.new.parse_arql(self, arql).find_options
          options.merge!(arql_options)
        end
        args << options
        find_without_arql(*args)
      end
    end
  end
end

ActiveRecord::Base.send(:include, Arql::ActiveRecordExt)
