require 'json'
require 'http'
require 'unity/client/version'
require 'unity/client/error'
require 'unity/client/response_error'
require 'unity/client/server_error'
require 'unity/client/response'
require 'unity/client/result'

module Unity
  class Client
    class Error < StandardError; end

    def initialize(endpoint, options = {})
      @endpoint = endpoint
      @access_key_id = options.fetch(:access_key_id) { ENV['UNITY_ACCESS_KEY_ID'] }
      @secret_access_key = options.fetch(:secret_access_key) { ENV['UNITY_SECRET_ACCESS_KEY'] }
      @http_connection_timeout = options.fetch(:http_connection_timeout, 5)
      @http_write_timeout = options.fetch(:http_write_timeout, 5)
      @http_read_timeout = options.fetch(:http_read_timeout, 10)
    end

    def get(operation_name, parameters = {}, options = {})
      resp = http_client.get(
        '/', params: { 'Operation' => operation_name }, json: parameters
      ).flush
      raise_error(resp) if resp.code >= 400

      Result.from_response(resp)
    end

    def post(operation_name, parameters = {}, options = {})
      resp = http_client.post(
        '/', params: { 'Operation' => operation_name }, json: parameters
      ).flush
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
      # raise a specific Exception when an internal server error occurs
      raise ServerError.from(resp) if resp.code >= 500

      raise ResponseError.from(resp)
    end
  end
end
