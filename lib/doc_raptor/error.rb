module DocRaptorError
  class NoApiKeyProvidedError   < RuntimeError; end
  class NoContentError          < ArgumentError; end
  class InvalidDownloadUrlError < ArgumentError; end
  class OptionsHashNotHash      < ArgumentError; end
end
