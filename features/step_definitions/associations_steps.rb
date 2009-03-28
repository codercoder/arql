
Given /member ([^ ]+) belongs to ([^ ]+)/ do |member_name, project_name|
  member = Member.find_by_name(member_name)
  project = Project.find_by_name(project_name)
  member.project = project
  member.save!
end

Given /project ([^ ]+) belongs to ([^ ]+)/ do |project_name, company_name|
  project = Project.find_by_name(project_name)
  company = Company.find_by_name(company_name)
  project.company = company
  project.save!
end

When /find member by arql: (.*)/ do |arql|
  @found_members = Member.find(:all, :arql => arql)
end

When /find project by arql: (.*)/ do |arql|
  @found_projects = Project.find(:all, :arql => arql)
end

Then /should find member: (.*)/ do |member_names|
  @found_members.collect(&:name).should == member_names.split(',').collect(&:strip)
end

Then /should find project: (.*)/ do |project_names|
  @found_projects.collect(&:name).should == project_names.split(',').collect(&:strip)
end
