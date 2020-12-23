# frozen_string_literal: true

module Unity
  class Client
    class ServerError < Error
      attr_reader :code, :headers, :body

      def self.from(response)
        new(response.code, response.headers, response.body.to_s)
      end

      def initialize(code, headers, body)
        @code = code
        @headers = headers
        @body = body
        super("server error with code: #{code}")
      end
    end
  end
end
