require File.join(File.dirname(__FILE__), '/test_helper.rb')

class ActiveRecordExtTest < Test::Unit::TestCase
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
    @kuli3 = User.create!(:name => 'kuli3')
  end

  def test_should_raise_error_when_aql_and_conditions_options_specified_at_same_time
    assert_raise Aql::WhyNotAql do
      User.find(:all, :aql => "name = 'kuli1'", :conditions => "name = 'kuli3'")
    end
  end

  def test_should_be_able_to_integrate_with_find_conditions_option
    assert_equal [@kuli1], User.find(:all, :aql => "name = 'kuli1' or name = 'kuli3'", :limit => 1)
  end

  def test_should_be_fine_to_use_default_conditions_option
    assert_equal [@kuli1], User.find(:all, :conditions => "name = 'kuli1'")
  end

  def test_find_first_with_aql_option
    assert_equal @kuli1, User.find(:first, :aql => "name = 'kuli1' or name = 'kuli3'")
  end
end
