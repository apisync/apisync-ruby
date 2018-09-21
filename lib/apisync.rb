require "bundler/setup"
require "httparty"
require "securerandom"
require "logger"

require "apisync/version"
require "apisync/exceptions"
require "apisync/resource"
require "apisync/http_client"
require "apisync/http/url"
require "apisync/http/query_string"

class Apisync
  @@api_key = nil
  @@host = nil

  # Verbose will do $stdout.puts. That's useful on a Rails console in
  # development, where logger output is ommited.
  @@verbose = false
  @@logger = ::Logger.new(IO::NULL)

  attr_accessor :verbose

  def initialize(api_key: nil, verbose: nil, logger: nil)
    @api_key = api_key || @@api_key
    @host = @@host
    @verbose = verbose || @@verbose

    @logger = logger || @@logger

    raise ArgumentError, "missing keyword: api_key" if @api_key.nil?
  end

  def method_missing(name, args = {}, &block)
    # overrides the instance api_key as `authorization`
    options = {
      host: @host,
      verbose: @verbose,
      logger: @logger
    }.merge(args).merge(api_key: @api_key)

    Apisync::Resource.new(name, options)
  end

  def self.host=(value)
    @@host = value
  end

  def self.api_key=(value)
    @@api_key = value
  end

  def self.verbose=(value)
    @@verbose = value
  end

  def self.logger=(value)
    @@logger = value
  end

  def self.verbose?
    !!@@verbose
  end
end
