module DocRaptorException
  class DocRaptorRequestException < StandardError
    attr_accessor :status_code
    attr_accessor :message
    def initialize(message, status_code)
      self.message     = message
      self.status_code = status_code
      super message
    end

    def to_s
      "#{self.class.name}\nHTTP Status: #{status_code}\nReturned: #{message}"
    end

    def inspect
      self.to_s
    end
  end
  class DocumentCreationFailure < DocRaptorRequestException; end
  class DocumentListingFailure  < DocRaptorRequestException; end
  class DocumentStatusFailure   < DocRaptorRequestException; end
  class DocumentDownloadFailure < DocRaptorRequestException; end
end
