class User < ActiveRecord::Base
end

class Member < ActiveRecord::Base
  belongs_to :project
end

class Project < ActiveRecord::Base
  belongs_to :company
  has_many :members
end

class Company < ActiveRecord::Base
  arql_id :name
  has_many :projects
end

Given /users: (.*)/ do |user_names|
  define_schema do
    create_table :users do |t|
      t.column :name, :string
    end
  end

  user_names.split(',').collect(&:strip).each do |user_name|
    User.create!(:name => user_name)
  end
end

Given /models: (.*)/ do |models|
  define_schema do
    if models =~ /project/i
      create_table :projects do |t|
        t.column :company_id, :integer
        t.column :name, :string
      end
    end
    if models =~ /member/i
      create_table :members do |t|
        t.column :project_id, :integer
        t.column :name, :string
      end
    end
    if models =~ /company/i
      create_table :companies do |t|
        t.column :name, :string
      end
    end
  end
end

Given /projects: (.*)/ do |names|
  names.split(',').collect(&:strip).each do |name|
    Project.create!(:name => name)
  end
end

Given /members: (.*)/ do |names|
  names.split(',').collect(&:strip).each do |name|
    Member.create!(:name => name)
  end
end

Given /companies: (.*)/ do |names|
  names.split(',').collect(&:strip).each do |name|
    Company.create!(:name => name)
  end
end
