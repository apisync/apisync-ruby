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
      if data[:id].nil?
        post(data)
      else
        put(data)
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
      http_client.get(
        resource_name: @name,
        id: conditions[:id],
        filters: conditions[:filters],
        options: @options
      )
    end

    private


    def post(data)
      http_client.post(
        resource_name: @name,
        data: data,
        options: @options
      )
    end

    def put(data)
      http_client.put(
        resource_name: @name,
        id: data[:id],
        data: data,
        options: @options
      )
    end

    private

    def http_client
      Apisync::HttpClient
    end
  end
end
