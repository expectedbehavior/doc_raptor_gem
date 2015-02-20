# -*- encoding: utf-8 -*-
$LOAD_PATH.push(File.expand_path "../lib", __FILE__)
require "doc_raptor/version"

Gem::Specification.new do |gem|
  gem.name          = "doc_raptor"
  gem.authors       = ["Michael Kuehl", "Joel Meador", "Chris Moore"]
  gem.email         = ["michael@expectedbehavior.com", "joel@expectedbehavior.com"]
  gem.description   = %q{Provides a simple ruby wrapper around the DocRaptor API}
  gem.summary       = %q{Provides a simple ruby wrapper around the DocRaptor API}
  gem.homepage      = "http://docraptor.com"
  gem.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  gem.files         = `git ls-files`.split("\n")
  gem.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  gem.require_paths = ["lib"]
  gem.version       = DocRaptor::VERSION

  gem.add_dependency "httparty", ">=0.7.0"

  gem.add_development_dependency "minitest", "~> 2.11.3"
  gem.add_development_dependency "pry"
  gem.add_development_dependency "rake"
  gem.add_development_dependency "webmock", "~> 1.8.2"
end
