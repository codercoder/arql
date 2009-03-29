module Arql
  module SqlHeler
    def quote(name, column=nil)
      ActiveRecord::Base.connection.quote(name, column)
    end

    def quote_table_name(name)
      ActiveRecord::Base.connection.quote_table_name(name)
    end

    def quote_column_name(name)
      ActiveRecord::Base.connection.quote_column_name(name)
    end

    def quote_name(table_name, column_name)
      "#{quote_table_name(table_name)}.#{quote_column_name(column_name)}"
    end
  end
end
