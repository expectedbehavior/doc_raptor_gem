require 'rubygems'
require 'doc_raptor'

DocRaptor.api_key "YOUR_API_KEY_HERE"

xls_html = "<table><tr><td>I am a test cell.</td><td>So am I</td></tr></table>"
File.open("docraptor_sample.xls", "w+") do |f| 
  f.write DocRaptor.create(:document_content => xls_html,
                           :name             => "docraptor_sample.xls",
                           :document_type    => "xls",
                           :test             => true)
end

pdf_html = '<html><body>I am a test doc!</body></html>'
File.open("docraptor_sample.pdf", "w+") do |f| 
  f.write DocRaptor.create(:document_content => pdf_html,
                           :name             => "docraptor_sample.pdf",
                           :document_type    => "pdf",
                           :test             => true)
end
