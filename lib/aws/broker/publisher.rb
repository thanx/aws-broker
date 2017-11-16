require 'aws/broker/base'

module Aws
  class Broker
    class Publisher < Base

      def initialize(topic, message)
        @topic = topic
        @message = message
      end

      def publish
        return unless enabled?
        create_topic
        sns.publish(
          topic_arn: @topic_arn,
          message:   @message.to_json
        )
      end

    end
  end
end
