class User < ActiveRecord::Base
end

Before do
  @options = {}
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

When /([a-z]+) => (.*)/ do |key, value|
  @options[key.to_sym] = value =~ /^\d+$/ ? value.to_i : value
end

Then /should find (.*)/ do |user_names|
  @found_users = User.find(:all, @options)
  @found_users.collect(&:name).should == user_names.split(',').collect(&:strip)
end

Then /find first should be (.*)/ do |user_name|
  @found_user = User.find(:first, @options)
  @found_user.name.should == user_name.strip
end

Then /should raise (.*)/ do |error|
  begin
    User.find(:all, @options)
  rescue => e
    @raised_error = e
  end
  @raised_error.class.should == error.constantize
end
