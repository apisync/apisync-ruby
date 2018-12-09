class Apisync
  module Http
    class QueryString
      def initialize(filters:)
        @filters = filters
      end

      def to_s
        result = ""
        result << format_filters if @filters
        result
      end

      private

      # Takes a list of `[key]=value` strings and maps them adding `"filter"`
      # as prefix.
      #
      # Results in `filter[key]=value&filter[key2]=value2`.
      def format_filters
        recursive_brackets(@filters)
          .flatten
          .map { |filter| "filter#{filter}" }
          .join("&")
      end

      # Takes a hash such as
      #
      #   {
      #     field_one: 'value1',
      #     metadata: {
      #       field_two: "value2",
      #       field_three: "value3"
      #     }
      #   }
      #
      # and returns
      #
      #   [
      #     "[field-one]=value1",
      #     "[metadata][field-two]=value2",
      #     "[metadata][field-three]=value3"
      #   ]
      #
      # This can be used for creating filter querystrings.
      def recursive_brackets(hash, prefix = "")
        result = []
        hash.each do |key, value|
          key = key.to_s
          if value.is_a?(Hash)
            prefix = "#{prefix}[#{key}]"
            top_nodes = recursive_brackets(value, prefix)
            result << top_nodes
          else
            result << "#{prefix}[#{key}]=#{value}"
          end
        end

        result
      end
    end
  end
end
