# frozen_string_literal: true

module UTMConversion
  module Capture
    # Middleware to capture UTM parameters from the query string
    class UTMParamsMiddleware
      UTM_PARAMS = %w[utm_source utm_medium utm_campaign utm_term utm_content].freeze

      def initialize(app)
        @app = app
      end

      def call(env)
        request = Rack::Request.new(env)
        utm_params = extract_utm_params(request)
        store_utm_data(env["rack.session"], utm_params)
        @app.call(env)
      end

      private

      def extract_utm_params(request)
        UTM_PARAMS.each_with_object({}) do |param, hash|
          hash[param] = request.params[param] if request.params[param]
        end
      end

      def store_utm_data(session, utm_params)
        return if utm_params.nil? || utm_params == {}

        UTMConversion::Session::UTMData.store(session, utm_params)
        UTMConversion.storage_adapter.store(session)
      end
    end
  end
end
