Gem::Specification.new do |spec|
  spec.name = 'aql'
  spec.version = "0.0.1"
  spec.summary = "AQL is an ActiveRecord Query Language."

  #### Dependencies and requirements.
  spec.files = ["lib/aql/active_record_ext.rb", "lib/aql/aql_grammer.rb", "lib/aql/aql_grammer.tab.rb", "lib/aql/parser.rb", "lib/aql/query.rb", "lib/aql.rb", "CHANGES", "aql.gemspec", "lib", "LICENSE.TXT", "Rakefile", "README.rdoc", "TODO"]

  spec.test_files = ["test/aql_find_by_association_test.rb", "test/aql_finder_test.rb", "test/parser_test.rb", "test/test_helper.rb"]

  #### Load-time details: library and application (you will need one or both).

  spec.require_path = 'lib'                         # Use these for libraries.

  #### Documentation and testing.

  spec.has_rdoc = true
  spec.extra_rdoc_files = ["README.rdoc", "LICENSE.txt", "TODO", "CHANGES"]
  spec.rdoc_options = ["--line-numbers", "--inline-source", "--main", "README.rdoc", "--title", "AQL -- ActiveRecord Query Language"]

  #### Author and project details.

  spec.author = "Wang Pengchao & Li Xiao"
  spec.homepage = "http://github.com/wpc/aql/tree/master"
end
