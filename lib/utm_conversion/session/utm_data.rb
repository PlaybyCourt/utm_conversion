# frozen_string_literal: true

module UTMConversion
  module Session
    # Stores the UTM parameters in the session
    class UTMData
      attr_reader :data

      def initialize(data)
        @data = data
      end

      def self.load(session)
        session[:utm_data]
      end

      def self.store(session, utm_params)
        session[:utm_data] = UTMData.new(utm_params) unless utm_params.nil?
      end
    end
  end
end
