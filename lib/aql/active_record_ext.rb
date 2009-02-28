require 'aql/parser'
module Aql
  class WhyNotAql < StandardError; end

  module ActiveRecordExt

    def self.included(base)
      base.extend(ClassMethods)
      class << base
        alias_method_chain :find, :aql
      end
    end

    module ClassMethods
      def find_with_aql(*args)
        options = args.extract_options!
        if aql = options.delete(:aql)
          raise WhyNotAql, 'Why not use :aql option to replace :conditions option?' if options[:conditions]
          aql_options = Parser.new.parse_aql(aql).find_options(self)
          options.merge!(aql_options)
        end
        args << options
        find_without_aql(*args)
      end
    end
  end
end

ActiveRecord::Base.send(:include, Aql::ActiveRecordExt)
