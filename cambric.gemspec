# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name = %q{cambric}
  s.version = "0.7.2"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.authors = ["Zachary Zolton", "Geoff Buesing"]
  s.date = %q{2009-09-02}
  s.email = %q{zachary.zolton@gmail.com}
  s.extra_rdoc_files = [
    "LICENSE",
     "README.rdoc"
  ]
  s.files = [
    ".document",
     ".gitignore",
     "LICENSE",
     "README.rdoc",
     "Rakefile",
     "VERSION",
     "cambric.gemspec",
     "lib/cambric.rb",
     "lib/cambric/assume_design_doc_name.rb",
     "lib/cambric/configurator.rb",
     "lib/cambric/file_manager.rb",
     "lib/cambric/test_helpers.rb",
     "spec/cambric/assume_design_doc_name_spec.rb",
     "spec/cambric/cambric_spec.rb",
     "spec/cambric/configurator_spec.rb",
     "spec/cambric/test_helpers_spec.rb",
     "spec/fixtures/twitter-clone-modified/tweets/views/by_follower_and_created_at/map.js",
     "spec/fixtures/twitter-clone-modified/users/views/bad/map.js",
     "spec/fixtures/twitter-clone-modified/users/views/bad/reduce.js",
     "spec/fixtures/twitter-clone-modified/users/views/followers/map.js",
     "spec/fixtures/twitter-clone-modified/users/views/followers/reduce.js",
     "spec/fixtures/twitter-clone/tweets/views/by_follower_and_created_at/map.js",
     "spec/fixtures/twitter-clone/users/views/bad/map.js",
     "spec/fixtures/twitter-clone/users/views/bad/reduce.js",
     "spec/fixtures/twitter-clone/users/views/followers/map.js",
     "spec/fixtures/twitter-clone/users/views/followers/reduce.js",
     "spec/spec.opts",
     "spec/spec_helper.rb"
  ]
  s.homepage = %q{http://github.com/zdzolton/cambric}
  s.rdoc_options = ["--charset=UTF-8"]
  s.require_paths = ["lib"]
  s.rubygems_version = %q{1.3.3}
  s.summary = %q{Opinionated management and usage of CouchDB from your Ruby apps.}
  s.test_files = [
    "spec/cambric/assume_design_doc_name_spec.rb",
     "spec/cambric/cambric_spec.rb",
     "spec/cambric/configurator_spec.rb",
     "spec/cambric/test_helpers_spec.rb",
     "spec/spec_helper.rb"
  ]

  if s.respond_to? :specification_version then
    current_version = Gem::Specification::CURRENT_SPECIFICATION_VERSION
    s.specification_version = 3

    if Gem::Version.new(Gem::RubyGemsVersion) >= Gem::Version.new('1.2.0') then
      s.add_runtime_dependency(%q<mattetti-couchrest>, [">= 0"])
    else
      s.add_dependency(%q<mattetti-couchrest>, [">= 0"])
    end
  else
    s.add_dependency(%q<mattetti-couchrest>, [">= 0"])
  end
end
