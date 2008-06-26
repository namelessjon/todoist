(in /home/jon/ruby/github/todoist)
Gem::Specification.new do |s|
  s.name = %q{todoist}
  s.version = "0.0.1"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.authors = ["Jonathan Stott"]
  s.date = %q{2008-06-26}
  s.description = %q{A gem which provides an interface for interacting with the todoist.com service.}
  s.email = ["jonathan.stott@gmail.com"]
  s.extra_rdoc_files = ["History.txt", "License.txt", "Manifest.txt", "README.txt", "website/index.txt"]
  s.files = ["History.txt", "License.txt", "Manifest.txt", "README.txt", "Rakefile", "config/hoe.rb", "config/requirements.rb", "lib/todoist.rb", "lib/todoist/connection.rb", "lib/todoist/errors.rb", "lib/todoist/version.rb", "script/console", "script/destroy", "script/generate", "script/txt2html", "setup.rb", "spec/spec.opts", "spec/spec_helper.rb", "spec/todoist_spec.rb", "tasks/deployment.rake", "tasks/environment.rake", "tasks/rspec.rake", "tasks/website.rake", "test/test_helper.rb", "test/test_todoist.rb", "website/index.html", "website/index.txt", "website/javascripts/rounded_corners_lite.inc.js", "website/stylesheets/screen.css", "website/template.html.erb"]
  s.has_rdoc = true
  s.homepage = %q{http://todoist.rubyforge.org}
  s.post_install_message = %q{}
  s.rdoc_options = ["--main", "README.txt"]
  s.require_paths = ["lib"]
  s.rubyforge_project = %q{todoist}
  s.rubygems_version = %q{1.2.0}
  s.summary = %q{A gem which provides an interface for interacting with the todoist.com service.}
  s.test_files = ["test/test_todoist.rb", "test/test_helper.rb"]

  if s.respond_to? :specification_version then
    current_version = Gem::Specification::CURRENT_SPECIFICATION_VERSION
    s.specification_version = 2

    if current_version >= 3 then
      s.add_runtime_dependency(%q<json>, [">= 1.1.2"])
    else
      s.add_dependency(%q<json>, [">= 1.1.2"])
    end
  else
    s.add_dependency(%q<json>, [">= 1.1.2"])
  end
end
