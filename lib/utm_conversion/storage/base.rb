# frozen_string_literal: true

module UTMConversion
  module Storage
    # Base class for storage adapters
    class Base
      def store(session_id, utm_params = nil)
        raise NotImplementedError
      end

      def retrieve(session_id)
        raise NotImplementedError
      end

      def record_conversion(session_id, event_data)
        raise NotImplementedError
      end
    end
  end
end
