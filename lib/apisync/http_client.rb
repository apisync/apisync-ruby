class Apisync
  class HttpClient
    VERSION_PREFIX = "".freeze

    HEADER = {
      "Content-Type" => "application/vnd.api+json",
      "Accept"       => "application/vnd.api+json"
    }.freeze

    def self.post(resource_name:, data:, options: {})
      url = Apisync::Http::Url.new(
        resource_name: resource_name,
        options: options
      )
      payload = payload_from_data(data)
      HTTParty.post(
        url.to_s,
        body: {data: payload}.to_json,
        headers: header(api_key: options[:api_key])
      )
    end

    def self.put(resource_name:, id:, data:, options: {})
      raise Apisync::UrlAndPayloadIdMismatch unless id == data[:id]

      url = Apisync::Http::Url.new(
        resource_name: resource_name,
        id: id,
        options: options
      )
      payload = payload_from_data(data)
      HTTParty.put(
        url.to_s,
        body: {data: payload}.to_json,
        headers: header(api_key: options[:api_key])
      )
    end

    def self.get(resource_name:, id: nil, filters: nil, options: {})
      raise Apisync::InvalidFilter if !filters.nil? && !filters.is_a?(Hash)

      url = Apisync::Http::Url.new(
        resource_name: resource_name,
        id: id,
        filters: filters,
        options: options
      )
      HTTParty.get(url.to_s, headers: header(api_key: options[:api_key]))
    end

    private

    def self.header(api_key: nil)
      final = HEADER
      if api_key
        final = final.merge("Authorization" => "ApiToken #{api_key}")
      end
      final
    end

    def self.payload_from_data(data)
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
  end
end
