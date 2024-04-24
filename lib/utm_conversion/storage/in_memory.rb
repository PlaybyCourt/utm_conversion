# frozen_string_literal: true

require "active_support/core_ext/object/blank"

module UTMConversion
  module Storage
    # In-memory storage adapter for UTM conversion data
    class InMemory < Base
      def initialize
        super
        @data = {}
      end

      def store(session, utm_params = nil)
        utm_data = utm_params || utm_data(session)
        return if utm_data.blank?

        @data[session.id] = {
          utm_data: utm_params || utm_data(session),
          conversions: []
        }
      end

      def retrieve(session_id)
        @data[session_id]&.fetch(:utm_data, nil)
      end

      def record_conversion(session, event_data)
        return if utm_data(session).blank?

        @data[session.id][:conversions] << event_data if @data[session_id]
      end

      private

      def utm_data(session)
        @utm_data ||= UTMConversion::Session::UTMData.load(session)
      end
    end
  end
end
