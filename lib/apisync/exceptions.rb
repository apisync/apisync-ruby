class Apisync
  class Exception < StandardError; end

  # List of exceptions. They are all inherited from Apisync::Exception
  class UrlAndPayloadIdMismatch < Apisync::Exception; end
  class InvalidFilter < Apisync::Exception; end
  class TooManyRequests < Apisync::Exception; end
end
