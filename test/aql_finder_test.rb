require File.join(File.dirname(__FILE__), '/test_helper.rb')

class AqlFinderTest < Test::Unit::TestCase
  class User < ActiveRecord::Base
  end

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
    assert_equal [@kuli1], User.find(:all, :aql => "name = 'kuli1'")
  end
  
  def test_find_by_unquoted_string_attribute_value
    assert_equal [@kuli1], User.find(:all, :aql => "name = kuli1")
  end
  
  def test_find_by_multiple_conditions
    assert_equal [@kuli1, @kuli2], User.find(:all, :aql => "name = kuli1 or name = kuli2")
    assert_equal [], User.find(:all, :aql => "name = kuli1 and name = kuli2")
  end

  def test_should_raise_column_invalid_when_column_name_does_not_exist
    assert_raise Aql::ColumnInvalid do
      User.find(:all, :aql => "non_exist_column_name = kuli1")
    end
  end
end
