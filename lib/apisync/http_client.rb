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
    end

    def post(data:, headers: {})
      wrap_response(HTTParty.post(
        url,
        body: {data: payload_from_data(data)}.to_json,
        headers: header.merge(headers)
      ))
    end

    def put(id:, data:, headers: {})
      raise Apisync::UrlAndPayloadIdMismatch unless id == data[:id]

      wrap_response(HTTParty.put(
        url(id: id),
        body: {data: payload_from_data(data)}.to_json,
        headers: header.merge(headers)
      ))
    end

    def get(id: nil, filters: nil, headers: {})
      raise Apisync::InvalidFilter if !filters.nil? && !filters.is_a?(Hash)

      wrap_response(HTTParty.get(
        url(id: id, filters: filters),
        headers: header.merge(headers)
      ))
    end

    private

    def url(id: nil, filters: nil)
      Apisync::Http::Url.new(
        resource_name: @resource_name,
        id: id,
        filters: filters,
        options: @options
      ).to_s
    end

    def header
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
        raise Apisync::TooManyRequests
      else
        response
      end
    end
  end
end
