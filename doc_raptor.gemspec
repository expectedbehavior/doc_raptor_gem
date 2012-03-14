# -*- encoding: utf-8 -*-
$LOAD_PATH.push(File.expand_path "../lib", __FILE__)
require "doc_raptor/version"

Gem::Specification.new do |gem|
  gem.name          = "doc_raptor"
  gem.authors       = ["Michael Kuehl", "Joel Meador", "Chris Moore"]
  gem.email         = ["michael@expectedbehavior.com"]
  gem.description   = %q{Provides a simple ruby wrapper around the DocRaptor API}
  gem.summary       = %q{Provides a simple ruby wrapper around the DocRaptor API}
  gem.homepage      = "http://docraptor.com"
  gem.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  gem.files         = ["Changelog.md",
                       "README.md",
                       "MIT-LICENSE",
                       "lib/doc_raptor/version.rb",
                       "lib/doc_raptor/error.rb",
                       "lib/doc_raptor/exception.rb",
                       "lib/doc_raptor.rb",
                       "lib/core_ext/object/blank.rb"]

  gem.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  gem.require_paths = ["lib"]
  gem.version       = DocRaptor::VERSION

  gem.add_dependency "httparty", ">=0.4.3"

  gem.add_development_dependency "minitest"
  gem.add_development_dependency "pry"
  gem.add_development_dependency "rake"
  gem.add_development_dependency "webmock"
end
