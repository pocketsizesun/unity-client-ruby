# frozen_string_literal: true

module Unity
  class Client
    class ResponseError < StandardError
      attr_reader :code, :headers, :body

      def self.from(response)
        new(response.code, response.headers, response.body.to_s)
      end

      def initialize(code, headers, body)
        @code = code
        @headers = headers
        @body = body
        super("response error with code: #{code}")
      end

      def data
        @data ||= JSON.parse(@body)
      end

      def error
        data['error']
      end

      def error_data
        data['data']
      end
    end
  end
end
