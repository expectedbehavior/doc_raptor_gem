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
      :async            => false,
    }
    options = default_options.merge(options)

    query = { }
    if options[:async]
      query[:output => 'json']
    end

    # HOTFIX
    # convert safebuffers to plain old strings so the gsub'ing that has to occur
    # for url encoding works
    # Broken by: https://github.com/rails/rails/commit/1300c034775a5d52ad9141fdf5bbdbb9159df96a#activesupport/lib/active_support/core_ext/string/output_safety.rb
    # Discussion: https://github.com/rails/rails/issues/1555
    options.map{|k,v| options[k] = options[k].to_str if options[k].is_a?(ActiveSupport::SafeBuffer)}
    # /HOTFIX

    response = post("/docs", :body => {:doc => options}, :basic_auth => { :username => api_key }, :query => query)

    if block_given?
      ret_val = nil
      Tempfile.open("docraptor") do |f|
        f.sync = true
        f.write(response.body)
        f.rewind

        ret_val = yield f, response
      end
      ret_val
    elsif options[:async]
      self.status_id = response.parsed_response["status_id"]
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
  
  def self.status(id = self.status_id)
    response = get("/status/#{id}", :basic_auth => { :username => api_key }, :output => 'json')

    json = response.parsed_response
    if json['status'] == 'completed'
      self.download_key = json['download_url'].match(/.*?\/download\/(.+)/)[1]
      json['download_key'] = self.download_key
    end
    json
  end

  def self.download(key = self.download_key)
    response = get("/download/#{key}")
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

  class << self
    attr_accessor :status_id
    attr_accessor :download_key
  end

  base_uri ENV["DOCRAPTOR_URL"] || "https://docraptor.com/"
  api_key  ENV["DOCRAPTOR_API_KEY"]
  
end
