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

    def get(path, parameters = {})
      resp = @http_client.get(path, params: parameters).flush
      raise_error(resp) if resp.code >= 400

      Unity::Client::Result.from_response(resp)
    end

    def post(path, parameters = {})
      resp = @http_client.post(path, json: parameters).flush
      raise_error(resp) if resp.code >= 400

      Unity::Client::Result.from_response(resp)
    end

    private

    def raise_error(resp)
      raise Unity::Client::ResponseError.from(resp)
    end
  end
end
