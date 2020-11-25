# frozen_string_literal: true

module Unity
  class Client
    class Response
      attr_reader :code, :headers, :body

      def self.from(response)
        new(response.code, response.headers, response.body.to_s)
      end

      def initialize(code, headers, body)
        @code = code
        @headers = headers
        @body = body
      end

      def data
        @data ||= JSON.parse(@body)
      end
    end
  end
end
