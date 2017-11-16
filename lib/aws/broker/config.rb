module Aws
  class Broker
    class Config

      attr_accessor :enabled
      alias_method :enabled?, :enabled

      attr_accessor :queue_prefix

      def initialize
        self.enabled = true
        self.queue_prefix = nil
      end

    end
  end
end
