
Given /member ([\w]+) belongs to ([\w]+)/ do |member_name, project_name|
  member = Member.find_by_name(member_name)
  project = Project.find_by_name(project_name)
  member.project = project
  member.save!
end

Given /project ([\w]+) belongs to ([\w]+)/ do |project_name, company_name|
  project = Project.find_by_name(project_name)
  company = Company.find_by_name(company_name)
  project.company = company
  project.save!
end
