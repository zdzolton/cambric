# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name = %q{cambric}
  s.version = "0.2.0"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.authors = ["Zachary Zolton", "Geoff Buesing"]
  s.date = %q{2009-05-18}
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
     "lib/cambric.rb",
     "spec/cambric_spec.rb",
     "spec/fixtures/degenerate.yml",
     "spec/fixtures/foo-bar-baz.yml",
     "spec/fixtures/twitter-clone.yml",
     "spec/fixtures/twitter-clone/tweets/views/by_follower_and_created_at/map.js",
     "spec/spec_helper.rb"
  ]
  s.has_rdoc = true
  s.homepage = %q{http://github.com/zdzolton/cambric}
  s.rdoc_options = ["--charset=UTF-8"]
  s.require_paths = ["lib"]
  s.rubygems_version = %q{1.3.1}
  s.summary = %q{Opinionated management and usage of CouchDB from your Ruby apps.}
  s.test_files = [
    "spec/cambric_spec.rb",
     "spec/spec_helper.rb"
  ]

  if s.respond_to? :specification_version then
    current_version = Gem::Specification::CURRENT_SPECIFICATION_VERSION
    s.specification_version = 2

    if Gem::Version.new(Gem::RubyGemsVersion) >= Gem::Version.new('1.2.0') then
      s.add_runtime_dependency(%q<jchris-couchrest>, [">= 1.0.5"])
    else
      s.add_dependency(%q<jchris-couchrest>, [">= 1.0.5"])
    end
  else
    s.add_dependency(%q<jchris-couchrest>, [">= 1.0.5"])
  end
end