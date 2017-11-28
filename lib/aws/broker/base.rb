module Aws
  class Broker
    class Base

    private

      def enabled?
        config.enabled?
      end

      def create_topic
        @topic_arn = sns.create_topic(name: topic_name).topic_arn
      end

      def topic_name
        if config.topic_prefix
          "#{config.topic_prefix}:#{@topic}"
        else
          @topic
        end
      end

      def sns
        @sns ||= Aws::SNS::Client.new
      end

      def config
        Broker.config
      end

    end
  end
end
