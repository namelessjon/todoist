require 'rake'
require 'rake/testtask'
require 'rake/rdoctask'
require 'rcov/rcovtask'

begin
  require 'jeweler'
  Jeweler::Tasks.new do |s|
    s.name = "todoist"
    s.summary = "a library for interacting with the Todoist public API"
    s.email = "jonathan.stott@gmail.com"
    s.homepage = "http://github.com/namelessjon/todoist"
    s.description = "The todoist gem offers convinience methods and wrappers for the todoist list management service, easing retrival and parsing of the responses.  It also offers a simple command-line client."
    s.authors = ["Jonathan Stott"]
    s.files   = FileList["lib/**/*.rb", "spec/**/*.rb", 'Rakefile', "[A-Z]+"]
    s.add_dependency('highline', '~> 1.5')
    s.add_dependency('thor', '~> 0.9')
    s.add_dependency('httparty', '~> 0.3')
  end
rescue LoadError
  puts "Jeweler not available. Install it with: sudo gem install technicalpickles-jeweler -s http://gems.github.com"
end

Rake::TestTask.new do |t|
  t.libs << 'lib'
  t.pattern = 'spec/**/*_spec.rb'
  t.verbose = true
end

Rake::RDocTask.new do |rdoc|
  rdoc.rdoc_dir = 'rdoc'
  rdoc.title    = 'Todoist'
  rdoc.options << '--line-numbers' << '--inline-source'
  rdoc.rdoc_files.include('README*')
  rdoc.rdoc_files.include('lib/**/*.rb')
end

Rcov::RcovTask.new do |t|
  t.libs << "spec"
  t.test_files = FileList['spec/**/*_spec.rb']
  t.verbose = true
end

task :default => :rcov
