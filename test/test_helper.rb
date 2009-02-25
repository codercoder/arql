require File.join(File.dirname(__FILE__), '/../lib/aql')

require 'test/unit'

ActiveRecord::Base.establish_connection(:adapter => "sqlite3", :dbfile => ":memory:")


class Test::Unit::TestCase

  def define_schema(&block)
    ActiveRecord::Base.connection.tables.each do |table|
      ActiveRecord::Base.connection.drop_table(table)
    end
    
    ActiveRecord::Base.silence do
      ActiveRecord::Migration.verbose = false
      ActiveRecord::Schema.define(:version => 1, &block)
    end
  end

end
