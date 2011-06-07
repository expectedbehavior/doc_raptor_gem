Gem::Specification.new do |s|
  s.name = %q{doc_raptor}
  s.description = %q{Provides a simple ruby wrapper around the DocRaptor API}
  s.summary = %q{Provides a simple ruby wrapper around the DocRaptor API}
  s.version = "0.1.4"
  s.date = %q{2011-06-07}
  s.authors = ["Michael Kuehl"]
  s.email = %q{michael@expectedbehavior.com}
  s.summary = %q{wrap up the api for DocRaptor nicely}
  s.homepage = %q{http://docraptor.com}
  s.require_paths = ["lib"]
  s.files = [ "README.md", "MIT-LICENSE", "lib/doc_raptor.rb"]
  
  [
   ["httparty", ">=0.4.3"],
  ].each do |gem_name, gem_version|
    s.add_dependency gem_name, gem_version
  end
end
