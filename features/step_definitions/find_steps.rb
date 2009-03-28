
When /^([a-z]+) => (.*)/ do |key, value|
  @options[key.to_sym] = value =~ /^\d+$/ ? value.to_i : value
end

When /find ([\w]+) by arql: (.*)/ do |model, arql|
  @options[:arql] = arql
end

Then /should find (\w+): (.*)/ do |model, names|
  @found = model.classify.constantize.find(:all, @options)
  @found.collect(&:name).should == names.split(',').collect(&:strip)
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
