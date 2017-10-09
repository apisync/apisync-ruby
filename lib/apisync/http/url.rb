class Apisync
  module Http

    # Responsible for generating URLs
    class Url
      DEFAULT_HOST = "https://api.apisync.io"

      # - resource_name: a name in plural such as 'users', 'profiles' etc.
      # - id: id of the resource that you're looking for
      # - filters: these will define what's in the query string, such as
      #   'filter[application-id]=value'
      # - options: allows you to pass options such 'host'. Accepted options are
      #
      #   - host: a custom host for the URL, defaults to DEFAULT_HOST
      def initialize(resource_name:, id: nil, filters: nil, options:)
        @resource_name = resource_name
        @id = id
        @filters = filters
        @options = {
          host: nil
        }.merge(options)
      end

      # to_s
      #
      # Takes a host, api_version, resource name and id and form the URL. Then
      # pass filters and other options into QueryString class which will return
      # whatever is after the `?` symbol.
      #
      # Returns a string such as
      #
      #    'https://api.apisync.io/inventory-items?filter[application-id]=abc'
      #
      # If there are no query strings, omits the `?`
      #
      #    'https://api.apisync.io/inventory-items'
      #
      def to_s
        url = [
          host,
          api_version,
          normalized_resource_name,
          @id
        ].compact.join("/")
        url = remove_duplicated_slashes(url)
        [url, query_string].compact.join("?")
      end

      private

      def api_version
        Apisync::HttpClient::VERSION_PREFIX
      end

      def host
        @options[:host] || DEFAULT_HOST
      end

      def query_string
        str = Apisync::Http::QueryString.new(filters: @filters).to_s
        str if str != ""
      end

      def normalized_resource_name
        @resource_name.to_s.downcase.gsub("_", "-")
      end

      def remove_duplicated_slashes(string)
        string.gsub(/([^:])\/\//, '\1/')
      end
    end
  end
end
