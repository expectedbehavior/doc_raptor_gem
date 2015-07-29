require "httparty"
require "tempfile"

["/core_ext/object/blank",
 "/doc_raptor/error",
 "/doc_raptor/exception"].each do |filename|
  require File.expand_path(File.dirname(__FILE__) + filename)
end

class DocRaptor
  include HTTParty

  default_options[:headers] = { "User-Agent" => "expectedbehavior_doc_raptor_gem/#{DocRaptor::VERSION} #{RUBY_ENGINE}/#{RUBY_VERSION}" }

  def self.api_key(key = nil)
    default_options[:api_key] = key ? key : default_options[:api_key] || ENV["DOCRAPTOR_API_KEY"]
    default_options[:api_key] || raise(DocRaptorError::NoApiKeyProvidedError.new("No API key provided"))
  end

  def self.api_key=(key)
    api_key(key)
  end

  def self.disable_agent_tracking
    default_options[:headers].delete("User-Agent")
  end

  def self.create!(options = {})
    raise(DocRaptorError::OptionsHashNotHash.new(".create! requires an options hash")) unless options.is_a?(Hash)
    self.create(options.merge(:raise_exception_on_failure => true))
  end

  # when given a block, hands the block a TempFile of the resulting document
  # otherwise, just returns the response
  def self.create(options = {})
    raise(DocRaptorError::OptionsHashNotHash.new(".create requires an options hash")) unless options.is_a?(Hash)
    if options[:document_content].blank? && options[:document_url].blank?
      raise(DocRaptorError::NoContentError.new("must supply :document_content or :document_url in options hash"))
    end

    default_options = {
      :name                       => "default",
      :document_type              => "pdf",
      :test                       => false,
      :async                      => false,
      :raise_exception_on_failure => false
    }
    options = default_options.merge(options)
    raise_exception_on_failure = options.delete(:raise_exception_on_failure)

    # HOTFIX
    # convert safebuffers to plain old strings so the gsub'ing that has to occur
    # for url encoding works
    # Broken by: https://github.com/rails/rails/commit/1300c034775a5d52ad9141fdf5bbdbb9159df96a#activesupport/lib/active_support/core_ext/string/output_safety.rb
    # Discussion: https://github.com/rails/rails/issues/1555
    if defined?(ActiveSupport) && defined?(ActiveSupport::SafeBuffer)
      options.map{ |k,v| options[k] = options[k].to_str if options[k].is_a?(ActiveSupport::SafeBuffer) }
    end
    # /HOTFIX

    response = post("/docs", :body => { :doc => options }, :basic_auth => { :username => api_key })

    if raise_exception_on_failure && !response.success?
      raise(DocRaptorException::DocumentCreationFailure.new(response.body, response.code))
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

  def self.list_docs!(options = {})
    raise(DocRaptorError::OptionsHashNotHash.new(".list_docs! requires an options hash")) unless options.is_a?(Hash)
    self.list_docs(options.merge(:raise_exception_on_failure => true))
  end

  def self.list_docs(options = {})
    raise(DocRaptorError::OptionsHashNotHash.new(".list_docs requires an options hash")) unless options.is_a?(Hash)
    default_options = {
      :page                       => 1,
      :per_page                   => 100,
      :raise_exception_on_failure => false
    }
    options = default_options.merge(options)
    raise_exception_on_failure = options.delete(:raise_exception_on_failure)

    response = get("/docs", :query => options, :basic_auth => { :username => api_key })
    if raise_exception_on_failure && !response.success?
      raise(DocRaptorException::DocumentListingFailure.new(response.body, response.code))
    end

    response
  end

  def self.status!(id)
    self.status(id, :raise_exception_on_failure => true)
  end

  def self.status(id, raise_exception_on_failure: false)
    response = get("/status/#{id}", :basic_auth => { :username => api_key }, :output => 'json')

    if raise_exception_on_failure && !response.success?
      raise(DocRaptorException::DocumentStatusFailure.new(response.body, response.code))
    end

    response.parsed_response
  end

  def self.download!(download_url)
    self.download(download_url, :raise_exception_on_failure => true)
  end

  def self.download(download_url, raise_exception_on_failure: false)
    unless matches = download_url.match(/.*?\/download\/(.+)/)
      raise(DocRaptorError::InvalidDownloadUrlError.new("download_url should match 'download/<id>', as returned by the status call in the 'download_url' field"))
    end
    key = matches[1]

    response = get("/download/#{key}")

    if raise_exception_on_failure && !response.success?
      raise(DocRaptorException::DocumentDownloadFailure.new(response.body, response.code))
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

  base_uri ENV["DOCRAPTOR_URL"] || "https://docraptor.com/"
end
