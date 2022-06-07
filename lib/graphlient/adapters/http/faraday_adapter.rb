require 'faraday'

module Graphlient
  module Adapters
    module HTTP
      class FaradayAdapter < Adapter
        def execute(document:, operation_name:, variables:, context:)
          response = connection.post do |req|
            req.headers.merge!(context[:headers] || {})
            req.body = {
              query: document.to_query_string,
              operationName: operation_name,
              variables: variables
            }.to_json
          end
          response.body
        rescue Faraday::ConnectionFailed => e
          raise Graphlient::Errors::ConnectionFailedError, e
        rescue Faraday::TimeoutError => e
          raise Graphlient::Errors::TimeoutError, e
        rescue Faraday::ClientError => e
          raise Graphlient::Errors::FaradayServerError, e
        rescue Faraday::ServerError => e
          raise Graphlient::Errors::FaradayServerError, e
        end

        def connection
          @connection ||= Faraday.new(url: url, headers: headers) do |c|
            c.response :raise_error
            c.request :json
            c.response :json, content_type: //

            configure_http_options(c.options)

            yield c if block_given?
          end
        end
      end
    end
  end
end
