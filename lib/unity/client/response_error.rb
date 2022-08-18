# frozen_string_literal: true

module Unity
  class Client
    class ResponseError < Error
      attr_reader :code, :headers, :body

      def self.from(response)
        new(response.code, response.headers, response.body.to_s)
      end

      def initialize(code, headers, body)
        @code = code
        @headers = headers
        @body = body
        @body_parsed = false
        @data = nil

        super("response error with code: #{code}")
      end

      def data
        return @data if @body_parsed == true

        @body_parsed = true
        @data = JSON.parse(@body)
      rescue JSON::ParserError
        nil
      end

      def error
        data&.fetch('error', nil)
      end

      def error_data
        data&.fetch('data', nil)
      end
    end
  end
end
