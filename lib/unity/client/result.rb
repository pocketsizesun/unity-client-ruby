# frozen_string_literal: true

module Unity
  class Client
    class Result
      def self.from_response(resp)
        body = resp.body.to_s

        new(
          if body.length > 0
            JSON.parse(body)
          else
            {}
          end
        )
      end

      def initialize(data)
        @data = data
      end

      def [](key)
        @data[key.to_s]
      end

      def method_missing(method_name, *args, &block)
        attr_name = method_name.name
        return @data[attr_name] if @data.key?(attr_name)

        super
      end

      def respond_to_missing?(method_name, include_private = true)
        @data.key?(method_name.name) || super
      end

      def as_json
        @data.as_json
      end

      def to_json(*args)
        @data.to_json(*args)
      end

      def to_h
        @data
      end
    end
  end
end
