Gem::Specification.new do |s|
  s.name = %q{doc-raptor}
  s.description = %q{Provides a simple ruby wrapper around the DocRaptor API}
  s.version = "0.1.0"
  s.date = %q{2010-10-20}
  s.authors = ["Michael Kuehl"]
  s.email = %q{michael@expectedbehavior.com}
  s.summary = %q{wrap up the api for DocRaptor nicely}
  s.homepage = %q{http://docraptor.com}
  s.files = [ "README.md", "MIT-LICENSE", "lib/doc_raptor.rb"]
  [
   ["httparty", ">=0.6.1"],
  ].each do |gem_name, gem_version|
    s.add_dependency gem_name, gem_version
  end
end
