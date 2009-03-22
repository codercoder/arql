$LOAD_PATH.unshift File.expand_path(File.dirname(__FILE__) + '/../../lib')
require 'arql'
require 'spec/expectations'

ActiveRecord::Base.establish_connection(:adapter => "sqlite3", :dbfile => ":memory:")

def define_schema(&block)
  ActiveRecord::Base.connection.tables.each do |table|
    ActiveRecord::Base.connection.drop_table(table)
  end
  
  ActiveRecord::Base.silence do
    ActiveRecord::Migration.verbose = false
    ActiveRecord::Schema.define(:version => 1, &block)
  end
end
