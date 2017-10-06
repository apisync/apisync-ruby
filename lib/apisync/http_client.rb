class Apisync
  class HttpClient
    VERSION_PREFIX = "".freeze

    HEADER = {
      "Content-Type" => "application/vnd.api+json",
      "Accept"       => "application/vnd.api+json"
    }.freeze

    def self.post(resource_name:, data:, api_key: nil, options: {})
      url = Apisync::Http::Url.new(
        resource_name: resource_name,
        options: options
      )
      HTTParty.post(url.to_s, body: {data: data}.to_json, headers: header(api_key: api_key))
    end

    def self.put(resource_name:, id:, data:, api_key: nil, options: {})
      raise Apisync::UrlAndPayloadIdMismatch unless id == data[:id]

      url = Apisync::Http::Url.new(
        resource_name: resource_name,
        id: id,
        options: options
      )
      HTTParty.put(url.to_s, body: {data: data}.to_json, headers: header(api_key: api_key))
    end

    def self.get(resource_name:, api_key: nil, id: nil, filters: nil, options: {})
      raise Apisync::InvalidFilter if !filters.nil? && !filters.is_a?(Hash)

      url = Apisync::Http::Url.new(
        resource_name: resource_name,
        id: id,
        filters: filters,
        options: options
      )
      HTTParty.get(url.to_s, headers: header(api_key: api_key))
    end

    private

    def self.header(api_key: nil)
      final = HEADER
      if api_key
        final = final.merge("Authorization" => "ApiToken #{api_key}")
      end
      final
    end
  end
end
