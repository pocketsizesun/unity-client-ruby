require 'json'
require 'http'
require 'unity/client/version'
require 'unity/client/error'
require 'unity/client/response_error'
require 'unity/client/response'
require 'unity/client/result'

module Unity
  class Client
    class Error < StandardError; end

    def initialize(endpoint, options = {})
      @endpoint = endpoint
      @access_key_id = options.fetch(:access_key_id) { ENV['UNITY_ACCESS_KEY_ID'] }
      @secret_access_key = options.fetch(:secret_access_key) { ENV['UNITY_SECRET_ACCESS_KEY'] }
      @http_client = HTTP.persistent(@endpoint).timeout(
        connect: options[:http_connection_timeout] || 5,
        write: options[:http_write_timeout] || 5,
        read: options[:http_read_timeout] || 10
      )

      http_options = { keep_alive_timeout: options[:keep_alive_timeout] || 15 }

      if options[:ssl_verify] == false
        ssl_context = OpenSSL::SSL::SSLContext.new
        ssl_context.verify_mode = OpenSSL::SSL::VERIFY_NONE
        http_options[:ssl_context] = ssl_context
      end

      @http_client.default_options = @http_client.default_options.merge(
        http_options
      )
    end

    def __client__
      @http_client
    end

    def get(operation_name, parameters = {}, options = {})
      resp = @http_client.get(
        '/', params: { 'Operation' => operation_name }, json: parameters
      ).flush
      raise_error(resp) if resp.code >= 400

      Result.from_response(resp)
    end

    def post(operation_name, parameters = {}, options = {})
      resp = @http_client.post(
        '/', params: { 'Operation' => operation_name }, json: parameters
      ).flush
      raise_error(resp) if resp.code >= 400

      Result.from_response(resp)
    end

    private

    def raise_error(resp)
      raise ResponseError.from(resp)
    end
  end
end
