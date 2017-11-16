require 'aws/broker/config'
require 'aws/broker/publisher'
require 'aws/broker/subscriber'

module Aws
  class Broker
    class << self

      def publish(topic, message)
        Publisher.new(topic, message).publish
      end

      def subscribe(topic)
        Subscriber.new(topic).subscribe
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
