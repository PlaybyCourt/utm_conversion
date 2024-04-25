# frozen_string_literal: true

module UTMConversion
  module Capture
    # Middleware to capture UTM parameters from the query string
    class UTMParamsMiddleware
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
        UTMConversion.utm_params.each_with_object({}) do |param, hash|
          value = request.params[param]

          next if value&.length&.> UTMConversion.max_utm_value_length

          hash[param] = request.params[param] if request.params[param]
        end
      end

      def store_utm_data(session, utm_params)
        return if utm_params.nil? || utm_params == {}

        UTMConversion::Session::UTMData.store(session, utm_params) if UTMConversion.store_utm_data_in_session
        UTMConversion.storage_adapter.store(session.id, utm_params) if UTMConversion.store_utm_date_in_storage_adapter
      end
    end
  end
end
