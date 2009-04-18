
Given /member ([\w\-\d]+) belongs to ([\w\-\d]+)/ do |member_name, project_name|
  member = Member.find_by_name(member_name)
  project = Project.find_by_name(project_name)
  member.project = project
  member.save!
end

Given /project ([\w\-\d]+) belongs to ([\w\-\d]+)/ do |project_name, company_name|
  project = Project.find_by_name(project_name)
  company = Company.find_by_name(company_name)
  project.company = company
  project.save!
end

Given /foo ([\w\-\d]+) belongs to ([\w\-\d]+)/ do |foo_name, belongs_to|
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
