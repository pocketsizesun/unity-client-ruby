# frozen_string_literal: true

module Unity
  class Client
    class Result
      attr_reader :code

      def self.from_response(resp)
        body = resp.body.to_s

        new(
          if body.length > 0
            JSON.parse(body)
          else
            {}
          end,
          resp.code
        )
      end

      def initialize(data, code = 200)
        @data = data
        @code = code
      end

      def [](key)
        @data[key.to_s]
      end

      def method_missing(method_name, *args, &block)
        attr_name = method_name.to_s
        return @data[attr_name] if @data.key?(attr_name)

        super
      end

      def respond_to_missing?(method_name, include_private = true)
        @data.key?(method_name.to_s) || super
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
