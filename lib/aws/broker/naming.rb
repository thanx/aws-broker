module Aws
  class Broker
    class Naming

      def queue(topic)
        if config.queue_prefix
          "#{config.queue_prefix}-#{topic(topic)}"
        else
          topic(topic)
        end
      end

      # http://docs.aws.amazon.com/sdk-for-ruby/v3/api/Aws/SNS/Resource.html
      #
      # Constraints: Topic names must be made up of only uppercase and
      # lowercase ASCII letters, numbers, underscores, and hyphens, and must
      # be between 1 and 256 characters long.
      def topic(topic)
        if config.topic_prefix
          "#{config.topic_prefix}_#{topic}"
        else
          topic
        end
      end

    private

      def config
        Broker.config
      end

    end
  end
end
