class Apisync
  class HttpClient
    VERSION_PREFIX = "".freeze

    HEADER = {
      "Content-Type" => "application/vnd.api+json",
      "Accept"       => "application/vnd.api+json"
    }.freeze

    def initialize(resource_name:, options: {})
      @resource_name = resource_name
      @options = options
      @logger = options[:logger] || ::Logger.new(IO::NULL)
    end

    def post(data:, headers: {})
      request_body = {data: payload_from_data(data)}
      url = request_url
      header = request_header.merge(headers)

      output_verbose_request(:post, url, request_body, header)

      wrap_response(HTTParty.post(
        request_url,
        body: request_body.to_json,
        headers: header
      ))
    end

    def put(id:, data:, headers: {})
      raise Apisync::UrlAndPayloadIdMismatch unless id == data[:id]

      request_body = {data: payload_from_data(data)}
      url = request_url(id: id)
      header = request_header.merge(headers)

      output_verbose_request(:put, url, request_body, header)

      wrap_response(HTTParty.put(
        url,
        body: request_body.to_json,
        headers: header
      ))
    end

    def get(id: nil, filters: nil, headers: {})
      raise Apisync::InvalidFilter if !filters.nil? && !filters.is_a?(Hash)

      url = request_url(id: id, filters: filters)
      output_verbose_request(:get, url)

      wrap_response(HTTParty.get(
        url,
        headers: request_header.merge(headers)
      ))
    end

    private

    def verbose?
      @options.fetch(:verbose, false)
    end

    def output_verbose_request(verb, url, body = nil, headers = nil)
      msg = "[APISync] Request: #{verb.to_s.upcase} #{url}"
      msg << " #{body.to_json}" if body
      log(msg)
    end

    def request_url(id: nil, filters: nil)
      Apisync::Http::Url.new(
        resource_name: @resource_name,
        id: id,
        filters: filters,
        options: @options
      ).to_s
    end

    def request_header
      final = HEADER
      final = final.merge("X-Request-Id" => ::SecureRandom.uuid)
      if @options[:api_key]
        final = final.merge("Authorization" => "ApiToken #{@options[:api_key]}")
      end
      final
    end

    def payload_from_data(data)
      transformed_payload = {}
      data.each do |key, value|
        if value.is_a?(Hash)
          transformed_payload[key.to_s] = payload_from_data(value)
        else
          new_key = key.to_s.gsub("_", "-").to_sym
          transformed_payload[new_key] = value
        end
      end
      transformed_payload
    end

    def wrap_response(response)
      if response.code.to_i == 429
        if verbose?
          log "[APISync] Response: 429 Too many requests at once, slow down."
        end
        raise Apisync::TooManyRequests
      else
        if verbose?
          msg = "[APISync] Response: #{response.code}"
          msg << " #{response.body}" if response.body != ""
          log msg
        end
        response
      end
    end

    def log(msg)
      $stdout.puts(msg) if verbose?
      @logger.info(msg)
    end
  end
end
