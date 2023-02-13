require 'json'
require 'http'
require 'unity/client/version'
require 'unity/client/error'
require 'unity/client/response_error'
require 'unity/client/response'
require 'unity/client/result'

module Unity
  class ClientV2
    class Error < StandardError; end

    def initialize(endpoint, options = {})
      @endpoint = endpoint
      @http_connection_timeout = options.fetch(:http_connection_timeout, 2)
      @http_write_timeout = options.fetch(:http_write_timeout, 3)
      @http_read_timeout = options.fetch(:http_read_timeout, 10)
    end

    def get(path, parameters = {})
      resp = http_client.get(path, params: parameters).flush
      raise_error(resp) if resp.code >= 400

      Result.from_response(resp)
    end

    def post(path, parameters = {})
      resp = http_client.post(path, json: parameters).flush
      raise_error(resp) if resp.code >= 400

      Result.from_response(resp)
    end

    private

    def http_client
      @http_client ||= HTTP.persistent(@endpoint).timeout(
        connect: @http_connection_timeout,
        write: @http_write_timeout,
        read: @http_read_timeout
      )
    end

    def raise_error(resp)
      raise ResponseError.from(resp)
    end
  end
end
