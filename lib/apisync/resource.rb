class Apisync
  class Resource
    def initialize(name, options = {})
      @name = name
      @options = options
    end

    # Saves a resource.
    #
    # When the resource has an id in `data`, a `PUT` request is done. Otherwise
    # a `POST` takes place.
    #
    def save(data)
      data[:type] = @name.to_s.gsub("_", "-")
      headers = data.delete(:headers) || {}

      if data[:id].nil?
        post(data, headers: headers)
      else
        put(data, headers: headers)
      end
    end

    # Returns all resources that match the conditions passed in.
    #
    # 1. To find a resource by its id:
    #
    #   get(id: 'customer-id')
    #
    # 2. To find a resource by a column value
    #
    #   get(filters: {column_name: 'customer-id' }})
    #
    def get(conditions)
      client = Apisync::HttpClient.new(
        resource_name: @name,
        options: @options
      )
      client.get(
        id: conditions[:id],
        filters: conditions[:filters],
        headers: conditions[:headers] || {}
      )
    end

    private


    def post(data, headers: {})
      client = Apisync::HttpClient.new(
        resource_name: @name,
        options: @options
      )
      client.post(
        data: data,
        headers: headers
      )
    end

    def put(data, headers: {})
      client = Apisync::HttpClient.new(
        resource_name: @name,
        options: @options
      )
      client.put(
        id: data[:id],
        data: data,
        headers: headers
      )
    end
  end
end
