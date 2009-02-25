require File.join(File.dirname(__FILE__), '/test_helper.rb')

class User < ActiveRecord::Base
end

class AqlFinderTest < Test::Unit::TestCase
  def setup
    define_schema do
      create_table :users do |t|
        t.column :name, :string
      end
    end
    @kuli1 = User.create!(:name => 'kuli1')
    @kuli2 = User.create!(:name => 'kuli2')
  end
  
  def test_find_by_string_attribute
    assert_equal [@kuli1], User.find_by_aql("name = 'kuli1'")
  end
  
  def test_find_by_unquoted_string_attribute_value
    assert_equal [@kuli1], User.find_by_aql("name = kuli1")
  end
  
  def test_find_by_multiple_conditions
    assert_equal [@kuli1, @kuli2], User.find_by_aql("name = kuli1 or name = kuli2")
    assert_equal [], User.find_by_aql("name = kuli1 and name = kuli2")
  end
end
