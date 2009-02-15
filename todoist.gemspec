# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name = %q{todoist}
  s.version = "0.1.0"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.authors = ["Jonathan Stott"]
  s.date = %q{2009-02-15}
  s.default_executable = %q{todoist}
  s.description = %q{The todoist gem offers convinience methods and wrappers for the todoist list management service, easing retrival and parsing of the responses.  It also offers a simple command-line client.}
  s.email = %q{jonathan.stott@gmail.com}
  s.executables = ["todoist"]
  s.files = ["lib/todoist/base.rb", "lib/todoist/project.rb", "lib/todoist/task.rb", "lib/todoist.rb", "spec/spec_helper.rb", "spec/todoist_spec.rb", "Rakefile", "bin/todoist"]
  s.has_rdoc = true
  s.homepage = %q{http://github.com/namelessjon/todoist}
  s.rdoc_options = ["--inline-source", "--charset=UTF-8"]
  s.require_paths = ["lib"]
  s.rubygems_version = %q{1.3.1}
  s.summary = %q{a library for interacting with the Todoist public API}

  if s.respond_to? :specification_version then
    current_version = Gem::Specification::CURRENT_SPECIFICATION_VERSION
    s.specification_version = 2

    if Gem::Version.new(Gem::RubyGemsVersion) >= Gem::Version.new('1.2.0') then
      s.add_runtime_dependency(%q<highline>, ["~> 1.5"])
      s.add_runtime_dependency(%q<thor>, ["~> 0.9"])
      s.add_runtime_dependency(%q<httparty>, ["~> 0.3"])
    else
      s.add_dependency(%q<highline>, ["~> 1.5"])
      s.add_dependency(%q<thor>, ["~> 0.9"])
      s.add_dependency(%q<httparty>, ["~> 0.3"])
    end
  else
    s.add_dependency(%q<highline>, ["~> 1.5"])
    s.add_dependency(%q<thor>, ["~> 0.9"])
    s.add_dependency(%q<httparty>, ["~> 0.3"])
  end
end
