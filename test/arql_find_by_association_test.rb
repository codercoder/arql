require File.join(File.dirname(__FILE__), '/test_helper.rb')

class ArqlFindByAssociationTest < Test::Unit::TestCase
  class User < ActiveRecord::Base
    belongs_to :project
  end

  class Project < ActiveRecord::Base
  end

  def setup
    define_schema do
      create_table :users do |t|
        t.column :project_id, :integer
        t.column :name, :string
      end
      create_table :projects do |t|
        t.column :name, :string
      end
    end
  end

  def test_find_by_belongs_to_association
    @arql = Project.create!(:name => 'arql')
    @kuli1 = User.create!(:name => 'kuli1', :project => @arql)
    @kuli2 = User.create!(:name => 'kuli2')

    assert_equal [@kuli1], User.find(:all, :arql => "project = #{@arql.id}")
  end

end
