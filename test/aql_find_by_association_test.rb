require File.join(File.dirname(__FILE__), '/test_helper.rb')

class AqlFindByAssociationTest < Test::Unit::TestCase
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
    @aql = Project.create!(:name => 'aql')
    @kuli1 = User.create!(:name => 'kuli1', :project => @aql)
    @kuli2 = User.create!(:name => 'kuli2')

    assert_equal [@kuli1], User.find_by_aql("project = #{@aql.id}")
  end

end
