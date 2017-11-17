require 'aws/broker/config'
require 'aws/broker/publisher'
require 'aws/broker/subscriber'

module Aws
  class Broker
    class << self

      def publish(*params)
        Publisher.new(*params).publish
      end

      def subscribe(*params)
        Subscriber.new(*params).subscribe
      end

      def config
        @config ||= Broker::Config.new
      end

      def configure
        yield(config)
      end

    end
  end
end
