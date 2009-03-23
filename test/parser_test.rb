require File.join(File.dirname(__FILE__), '/test_helper.rb')

class ParserTest < Test::Unit::TestCase

  class User < ActiveRecord::Base
  end

  def setup
    define_schema do
      create_table :users do |t|
        t.column :name, :string
      end
    end
    @parser = Arql::Parser.new
  end

  def test_parse_identifier
    assert_equal({:conditions => 'name = \'kuli\''}, @parser.parse_arql(User, 'name = kuli').find_options)
  end

  def test_parse_number
    assert_equal({:conditions => 'id = 2'}, @parser.parse_arql(User, 'id = 2').find_options)
  end
end
