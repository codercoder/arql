require 'aql/parser'
module Aql
  module ActiveRecordExt

    def self.included(base)
      base.extend(ClassMethods)
    end

    module ClassMethods
      def find_by_aql(str)
        find(:all, Parser.new.parse_aql(str).find_options)
      end
    end
  end
end

ActiveRecord::Base.send(:include, Aql::ActiveRecordExt)
