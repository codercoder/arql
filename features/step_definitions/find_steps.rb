
When /parse with user model: (.*)/ do |arql|
  @options = Arql::Parser.new.parse_arql(User, arql).find_options
end

When /^([a-z]+) => (.*)/ do |key, value|
  @options[key.to_sym] = value =~ /^\d+$/ ? value.to_i : value
end

Then /should find user: (.*)/ do |user_names|
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

Then /should output: (.*)/ do |options|
  expected_options = eval(options)
  @options.should == expected_options
end
