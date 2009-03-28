When /parse with user model: (.*)/ do |arql|
  @parsed_output = Arql::Parser.new.parse_arql(User, arql).find_options
end

Then /should output: (.*)/ do |options|
  expected_options = eval(options)
  @parsed_output.should == expected_options
end
