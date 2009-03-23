class User < ActiveRecord::Base
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

When /find user by arql: (.*)/ do |arql|
  begin
    @found_users = User.find(:all, :arql => arql)
  rescue => e
    @raised_error = e
  end
end

Then /should find (.*)/ do |user_names|
  @found_users.collect(&:name).should == user_names.split(',').collect(&:strip)
end

Then /should raise (.*)/ do |error|
  @raised_error.class.should == error.constantize
end
