module Aws
  class Broker
    class Config

      attr_accessor :enabled, :queue_prefix
      attr_accessor :aws_access_key, :aws_secret_key, :aws_region
      alias_method :enabled?, :enabled

      def initialize
        self.enabled        = true
        self.queue_prefix   = nil
        self.aws_access_key = nil
        self.aws_secret_key = nil
        self.aws_region     = nil
      end

    end
  end
end
