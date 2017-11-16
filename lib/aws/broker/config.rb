module Aws
  class Broker
    class Config

      attr_accessor :enabled
      alias_method :enabled?, :enabled

      def initialize
        self.enabled = true
      end

    end
  end
end
