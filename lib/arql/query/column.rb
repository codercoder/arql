require 'arql/sql_helper'

module Arql

  class ColumnInvalid < StandardError; end

  module Query

    class Column
      include SqlHeler

      attr_reader :join, :arql_name

      def initialize(model, arql_name)
        @model = model
        @arql_name = arql_name
        init_column_model_and_name
      end

      def expression_sql(opt, right)
        "#{quoted_full_name} #{opt} #{quote_value(right)}"
      end

      def quoted_full_name
        quote_name(@column_model.table_name, @column_name)
      end

      private
      def quote_value(value)
        origin_column = @column_model.columns_hash[@column_name]
        quote(value, origin_column)
      end

      def init_column_model_and_name
        if origin_column = @model.columns_hash[@arql_name]
          @column_name = origin_column.name
          @column_model = @model
        elsif ref = @model.reflections[@arql_name.to_sym]
          if ref.klass.arql_id
            @column_model = ref.klass
            @column_name = @column_model.arql_id
            @join = ref.name.to_sym
          else
            @column_model = @model
            @column_name = ref.primary_key_name
          end
        elsif ref = reflection_of_specified_comparision_name_in_arql
          #specified comparision name in arql: project.name = 'arql'
          @column_model = ref.klass
          @column_name = @arql_name.split('.').last
          @join = ref.name.to_sym
        else
          raise column_invalid
        end
      end

      def column_invalid
        ColumnInvalid.new "Couldn't figure out what's means #{@arql_name.inspect} for #{@model.inspect}."
      end

      def reflection_of_specified_comparision_name_in_arql
        if @arql_name =~ /.+\..+/
          reflection_name = @arql_name.split('.').first
          @model.reflections[reflection_name.to_sym]
        end
      end
    end

  end
end
