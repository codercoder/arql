module FindSteps
  class User < ActiveRecord::Base
  end
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
    FindSteps::User.create!(:name => user_name)
  end
end

When /parse with user model: (.*)/ do |arql|
  @options = Arql::Parser.new.parse_arql(FindSteps::User, arql).find_options
end

When /^([a-z]+) => (.*)/ do |key, value|
  @options[key.to_sym] = value =~ /^\d+$/ ? value.to_i : value
end

Then /should find (.*)/ do |user_names|
  @found_users = FindSteps::User.find(:all, @options)
  @found_users.collect(&:name).should == user_names.split(',').collect(&:strip)
end

Then /find first should be (.*)/ do |user_name|
  @found_user = FindSteps::User.find(:first, @options)
  @found_user.name.should == user_name.strip
end

Then /should raise (.*)/ do |error|
  begin
    FindSteps::User.find(:all, @options)
  rescue => e
    @raised_error = e
  end
  @raised_error.class.should == error.constantize
end

Then /should output: (.*)/ do |options|
  expected_options = eval(options)
  p expected_options
  @options.should == expected_options
end
