require "httparty"
require "tempfile"

class DocRaptor
  include HTTParty
  
  def self.api_key(key = nil)
    return default_options[:api_key] unless key
    default_options[:api_key] = key
  end

  # when given a block, hands the block a TempFile of the resulting document
  # otherwise, just returns the response
  def self.create(options = { })
    raise "must supply :document_content" if options[:document_content].blank?
    
    default_options = { 
      :name             => "default",
      :document_type    => "pdf",
      :test             => false,
    }
    options = default_options.merge(options)
    
    response = post("/docs", :body => {:doc => options}, :basic_auth => { :username => api_key })
    
    if block_given?
      Tempfile.open("docraptor") do |f|
        f.sync = true
        f.write(response.body)
        f.rewind

        yield f, response
      end
    else
      response
    end
  end
  
  base_uri ENV["DOCRAPTOR_URL"] || "https://docraptor.com/"
  api_key  ENV["DOCRAPTOR_API_KEY"]
  
end
