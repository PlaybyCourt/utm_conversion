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

      def store(session_id, utm_params = nil)
        utm_data = utm_params || utm_data(session)
        return if utm_data.nil? || utm_data == {}

        @data[session_id] = {
          utm_data: utm_data,
          conversions: []
        }
      end

      def retrieve(session_id)
        @data[session_id]&.fetch(:utm_data, nil)
      end

      def record_conversion(session_id, event_data)
        @data[session_id][:conversions] << event_data if @data[session_id]
      end
    end
  end
end
