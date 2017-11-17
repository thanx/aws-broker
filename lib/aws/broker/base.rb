module Aws
  class Broker
    class Base

    private

      def enabled?
        config.enabled?
      end

      def create_topic
        @topic_arn = sns.create_topic(name: @topic).topic_arn
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
