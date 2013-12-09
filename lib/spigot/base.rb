require 'active_record'
module Spigot
  module Base
    def self.included(base)
      base.send(:extend, self::ClassMethods)
      base.send(:extend, Spigot::ActiveRecord::ClassMethods) if active_record?(base)
    end

    module ClassMethods
      # #self.new_by_api(service, api_data)
      # Instantiate a new object mapping the api data to the calling object's attributes
      #
      # @param service [Symbol] Service which will be doing the translating. Must have a corresponding yaml file
      # @param api_data [Hash] The data as received from the remote api, unformatted.
      def new_by_api(service, api_data)
        Record.instantiate(self, formatted_api_data(service, api_data))
      end

      # #self.formatted_api_data(service, api_data)
      # Create a Spigot::Translator for the given service and return the formatted data.
      #
      # @param service [Symbol] Service which will be doing the translating. Must have a corresponding yaml file
      # @param api_data [Hash] The data as received from the remote api, unformatted.
      def formatted_api_data(service, api_data)
        Translator.new(service, self, api_data).format
      end

      # #self.spigot
      # Return a Spigot::Proxy that provides accessor methods to the spigot library
      #
      # @param service [Symbol] Service which pertains to the data being processed on the implementation
      def spigot(service)
        Spigot::Proxy.new(service, self)
      end
    end

    private

    def self.active_record?(klass)
      defined?(ActiveRecord) && klass < ::ActiveRecord::Base
    end
  end
end