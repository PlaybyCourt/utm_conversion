# frozen_string_literal: true

require_relative "utm_conversion/version"
require "utm_conversion/capture/utm_params_middleware"
require "utm_conversion/storage/base"
require "utm_conversion/storage/in_memory" # Default storage adapter
require "utm_conversion/session/utm_data"

# UTMConversion module
# This module is the main entry point for the UTMConversion gem
# It provides a configuration interface and sets up the default storage adapter
module UTMConversion
  class Error < StandardError; end

  class << self
    attr_accessor :storage_adapter

    def configure
      yield self
    end

    def retrieve_utm_data(session)
      storage_adapter.retrieve(session)
    end

    def store_utm_data(session, utm_data)
      storage_adapter.store(session, utm_data)
    end

    def record_conversion(session, event_data)
      storage_adapter.record_conversion(session, event_data)
    end
  end

  self.storage_adapter ||= UTMConversion::Storage::InMemory.new
end
