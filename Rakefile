# Rakefile for ARQL        -*- ruby -*-

$LOAD_PATH.unshift File.expand_path(File.dirname(__FILE__) + '/lib')
require 'arql'

require 'rake/testtask'
require 'rake/rdoctask'

require 'rubygems'
require 'rake/gempackagetask'

# The default task is run if rake is given no explicit arguments.

desc "Default Task"
task :default => :test

Rake::TestTask.new(:test) do |t|
  t.test_files = FileList['test/*_test.rb']
  t.warning = true
  t.verbose = false
end

desc "generate arql parser by racc, need racc installed"
task :racc do
  %x[racc lib/arql/arql_grammer.rb]
end

# Create a task to build the RDOC documentation tree.

rd = Rake::RDocTask.new("rdoc") { |rdoc|
  rdoc.rdoc_dir = 'html'
  rdoc.template = 'html'
  rdoc.title    = "ARQL -- ActiveRecord Query Language"
  rdoc.options << '--line-numbers' << '--inline-source' <<
    '--main' << 'README.rdoc' <<
    '--title' <<  'ARQL -- ActiveRecord Query Language'
  rdoc.rdoc_files.include('README.rdoc', 'LICENSE.txt', 'TODO', 'CHANGES')
  rdoc.rdoc_files.include('lib/**/*.rb')
}

# ====================================================================
# Create a task that will package the DTR software into distributable
# tar, zip and gem files.

if ! defined?(Gem)
  puts "Package Target requires RubyGEMs"
else
  if Arql::VERSION.to_i >= 1
    gem_content = <<-GEM
  Gem::Specification.new do |spec|
    spec.name = 'arql'
    spec.version = "#{Arql::VERSION}"
    spec.summary = "ARQL is an ActiveRecord Query Language."

    #### Dependencies and requirements.
    spec.files = #{(Dir.glob("lib/**/*.rb") + ["CHANGES", "arql.gemspec", "lib", "LICENSE.TXT", "Rakefile", "README.rdoc", "TODO"]).inspect}

    spec.test_files = #{Dir.glob("test/**/*.rb").inspect}

    #### Load-time details: library and application (you will need one or both).

    spec.require_path = 'lib'                         # Use these for libraries.

    #### Documentation and testing.

    spec.has_rdoc = true
    spec.extra_rdoc_files = #{rd.rdoc_files.reject { |fn| fn =~ /\.rb$/ }.to_a.inspect}
    spec.rdoc_options = #{rd.options.inspect}

    #### Author and project details.

    spec.author = "Wang Pengchao & Li Xiao"
    spec.homepage = "http://github.com/codercoder/arql/tree/master"
  end
  GEM
    File.open(File.dirname(__FILE__) + '/arql.gemspec', 'w') do |f|
      f.write(gem_content)
    end

    #build gem package same steps with github
    File.open(File.dirname(__FILE__) + '/arql.gemspec') do |f|
      data = f.read
      spec = nil
      Thread.new { spec = eval("$SAFE = 3\n#{data}") }.join
      package_task = Rake::GemPackageTask.new(spec) do |pkg|
        #pkg.need_zip = true
        #pkg.need_tar = true
      end
    end
  end
end

# Misc tasks =========================================================

def count_lines(filename)
  lines = 0
  codelines = 0
  open(filename) { |f|
    f.each do |line|
      lines += 1
      next if line =~ /^\s*$/
      next if line =~ /^\s*#/
      codelines += 1
    end
  }
  [lines, codelines]
end

def show_line(msg, lines, loc)
  printf "%6s %6s   %s\n", lines.to_s, loc.to_s, msg
end

desc "Count lines in the main files"
task :lines do
  total_lines = 0
  total_code = 0
  show_line("File Name", "LINES", "LOC")
  FileList['lib/**/*.rb', 'lib/**/*.rake'].each do |fn|
    lines, codelines = count_lines(fn)
    show_line(fn, lines, codelines)
    total_lines += lines
    total_code  += codelines
  end
  show_line("TOTAL", total_lines, total_code)
end

# Support Tasks ------------------------------------------------------

RUBY_FILES = FileList['**/*.rb'].exclude('pkg')

desc "Look for TODO and FIXME tags in the code"
task :todo do
  RUBY_FILES.egrep(/#.*(FIXME|TODO|TBD)/)
end

