
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

Given /foo ([\w]+) belongs to ([\w]+)/ do |foo_name, belongs_to|
  foo = Foo.find_by_name(foo_name)
  if TableNameIsSelect.table_exists?
    foo.table_name_is_select = TableNameIsSelect.find_by_name(belongs_to)
  elsif ColumnNameIsFrom.table_exists?
    foo.column_name_is_from = ColumnNameIsFrom.find_by_from(belongs_to)
  else
    raise "couldn't find TableNameIsSelect or ColumnNameIsFrom by #{belongs_to.inspect}"
  end
  foo.save!
end
