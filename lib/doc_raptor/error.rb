module DocRaptorError
  class NoApiKeyProvidedError < RuntimeError; end
  class NoContentError        < ArgumentError; end
end
