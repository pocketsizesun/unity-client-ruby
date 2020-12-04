require 'json'
require 'http'
require 'symbol-fstring'
require 'unity/client/version'
require 'unity/client/response'
require 'unity/client/response_error'
require 'unity/client/result'

Symbol.alias_method(:to_s, :name)

module Unity
  class Client
    class Error < StandardError; end

    def initialize(endpoint, options = {})
      @endpoint = endpoint
      @access_key_id = options.fetch(:access_key_id) { ENV['UNITY_ACCESS_KEY_ID'] }
      @secret_access_key = options.fetch(:secret_access_key) { ENV['UNITY_SECRET_ACCESS_KEY'] }
    end

    def get(operation_name, parameters = {}, options = {})
      resp = http_client.get(
        '/', params: { 'Operation' => operation_name }, json: parameters
      )
      raise ResponseError.from(resp) unless resp.code == 200

      Result.new(JSON.parse(resp.body.to_s))
    end

    def post(operation_name, parameters = {}, options = {})
      resp = http_client.post(
        '/', params: { 'Operation' => operation_name }, json: parameters
      )
      raise ResponseError.from(resp) unless resp.code == 200

      Result.new(JSON.parse(resp.body.to_s))
    end

    private

    def http_client
      @http_client ||= HTTP.persistent(@endpoint)
    end
  end
end
