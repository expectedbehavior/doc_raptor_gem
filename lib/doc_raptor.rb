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
    if options[:document_content].blank? && options[:document_url].blank?
      raise "must supply :document_content or :document_url" 
    end
    
    default_options = { 
      :name             => "default",
      :document_type    => "pdf",
      :test             => false,
    }
    options = default_options.merge(options)
    
    response = post("/docs", :body => {:doc => options}, :basic_auth => { :username => api_key })
    
    if block_given?
      ret_val = nil
      Tempfile.open("docraptor") do |f|
        f.sync = true
        f.write(response.body)
        f.rewind

        ret_val = yield f, response
      end
      ret_val
    else
      response
    end
  end
  
  def self.list_docs(options = { })
    default_options = { 
      :page     => 1,
      :per_page => 100
    }
    options = default_options.merge(options)
    
    get("/docs", :query => options, :basic_auth => { :username => api_key })
  end
  
  base_uri ENV["DOCRAPTOR_URL"] || "https://docraptor.com/"
  api_key  ENV["DOCRAPTOR_API_KEY"]
  
end
