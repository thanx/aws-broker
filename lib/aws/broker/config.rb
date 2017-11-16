module Aws
  class Broker
    class Config

      attr_accessor :enabled, :queue_prefix
      alias_method :enabled?, :enabled

      def initialize
        self.enabled        = true
        self.queue_prefix   = nil
      end

    end
  end
end
