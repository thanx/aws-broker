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
        @sns ||= Aws::SNS::Client.new(credentials)
      end

      def credentials
        {
          access_key_id:     config.aws_access_key,
          secret_access_key: config.aws_secret_key,
          region:            config.aws_region
        }
      end

      def config
        Broker.config
      end

    end
  end
end
