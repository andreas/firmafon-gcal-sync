require "httparty"
require "json"
require "./hash_ext"

module Firmafon
  class Client
    class Error < StandardError; end

    include HTTParty

    base_uri "https://app.firmafon.dk/api/v1"
    format :json
    headers "Accept"       => "application/json",
            "Content-Type" => "application/json"

    def initialize(app_key)
      @app_key = app_key
    end

    def user_key(email, password)
      post "/user_keys", body: { email: email, password: password }
    end

    def employee(user_token)
      get "/employee", query: { "user_key" => user_token }
    end

    def set_employee(user_token, values)
      post "/employee", query: { "user_key" => user_token }, body: values
    end

    def post(path, options={})
      request :post, path, options
    end

    def get(path, options={})
      request :get, path, options
    end

    def request(method, path, options={})
      options[:body] = JSON.dump(options[:body]) if options[:body].is_a?(Hash)

      response = self.class.send method, path, options.deep_merge(query: { "app_key" => @app_key })

      raise Error unless response.success?

      response.parsed_response
    end
  end
end
