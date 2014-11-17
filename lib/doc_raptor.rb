require "httparty"
require "tempfile"

["/core_ext/object/blank",
 "/doc_raptor/error",
 "/doc_raptor/exception"].each do |filename|
  require File.expand_path(File.dirname(__FILE__) + filename)
end

class DocRaptor
  include HTTParty

  def self.api_key(key = nil)
    default_options[:api_key] = key ? key : default_options[:api_key] || ENV["DOCRAPTOR_API_KEY"]
    default_options[:api_key] || raise(DocRaptorError::NoApiKeyProvidedError.new("No API key provided"))
  end

  def self.create!(options = {})
    raise ArgumentError.new "please pass in an options hash" unless options.is_a? Hash
    self.create(options.merge({:raise_exception_on_failure => true}))
  end

  # when given a block, hands the block a TempFile of the resulting document
  # otherwise, just returns the response
  def self.create(options = { })
    raise ArgumentError.new "please pass in an options hash" unless options.is_a? Hash
    if options[:document_content].blank? && options[:document_url].blank?
      raise DocRaptorError::NoContentError.new("must supply :document_content or :document_url")
    end

    default_options = {
      :name                       => "default",
      :document_type              => "pdf",
      :test                       => false,
      :async                      => false,
      :raise_exception_on_failure => false
    }
    options = default_options.merge(options)
    raise_exception_on_failure = options[:raise_exception_on_failure]
    options.delete :raise_exception_on_failure

    # HOTFIX
    # convert safebuffers to plain old strings so the gsub'ing that has to occur
    # for url encoding works
    # Broken by: https://github.com/rails/rails/commit/1300c034775a5d52ad9141fdf5bbdbb9159df96a#activesupport/lib/active_support/core_ext/string/output_safety.rb
    # Discussion: https://github.com/rails/rails/issues/1555
    if defined?(ActiveSupport) && defined?(ActiveSupport::SafeBuffer)
      options.map{|k,v| options[k] = options[k].to_str if options[k].is_a?(ActiveSupport::SafeBuffer)}
    end
    # /HOTFIX

    response = post("/docs", :body => {:doc => options}, :basic_auth => {:username => api_key})

    if raise_exception_on_failure && !response.success?
      raise DocRaptorException::DocumentCreationFailure.new response.body, response.code
    end

    if response.success? && options[:async]
      self.status_id = response.parsed_response["status_id"]
    end

    if block_given?
      ret_val = nil
      Tempfile.open("docraptor", :encoding => "ascii-8bit") do |f|
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

  def self.list_docs!(options = { })
    raise ArgumentError.new "please pass in an options hash" unless options.is_a? Hash
    self.list_docs(options.merge({:raise_exception_on_failure => true}))
  end

  def self.list_docs(options = { })
    raise ArgumentError.new "please pass in an options hash" unless options.is_a? Hash
    default_options = {
      :page     => 1,
      :per_page => 100,
      :raise_exception_on_failure => false
    }
    options = default_options.merge(options)
    raise_exception_on_failure = options[:raise_exception_on_failure]
    options.delete :raise_exception_on_failure

    response = get("/docs", :query => options, :basic_auth => { :username => api_key })
    if raise_exception_on_failure && !response.success?
      raise DocRaptorException::DocumentListingFailure.new response.body, response.code
    end

    response
  end

  def self.status!(id = self.status_id)
    self.status(id, true)
  end

  def self.status(id = self.status_id, raise_exception_on_failure = false)
    response = get("/status/#{id}", :basic_auth => { :username => api_key }, :output => 'json')

    if raise_exception_on_failure && !response.success?
      raise DocRaptorException::DocumentStatusFailure.new response.body, response.code
    end

    json = response.parsed_response
    if json['status'] == 'completed'
      self.download_key = json['download_url'].match(/.*?\/download\/(.+)/)[1]
      json['download_key'] = self.download_key
    end
    json
  end

  def self.download!(key = self.download_key)
    self.download(key, true)
  end

  def self.download(key = self.download_key, raise_exception_on_failure = false)
    response = get("/download/#{key}")

    if raise_exception_on_failure && !response.success?
      raise DocRaptorException::DocumentDownloadFailure.new response.body, response.code
    end

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
end
