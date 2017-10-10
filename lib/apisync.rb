require "bundler/setup"
require "httparty"

require "apisync/version"
require "apisync/exceptions"
require "apisync/resource"
require "apisync/http_client"
require "apisync/http/url"
require "apisync/http/query_string"

class Apisync
  @@api_key = nil

  def initialize(api_key: nil)
    @api_key = api_key || @@api_key

    raise ArgumentError, "missing keyword: api_key" if @api_key.nil?
  end

  def method_missing(name, args = {}, &block)
    # overrides the instance api_key as `authorization`
    options = args.merge(authorization: @api_key)
    Apisync::Resource.new(name, options)
  end

  def self.api_key=(key)
    @@api_key = key
  end
end
