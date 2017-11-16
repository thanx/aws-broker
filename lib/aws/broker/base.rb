module Aws
  class Broker
    class Base

    private

      def enabled?
        Broker.config.enabled?
      end

      def create_topic
        @topic_arn = sns.create_topic(name: @topic).topic_arn
      end

      def sns
        @sns ||= Aws::SNS::Client.new(credentials)
      end

      def credentials
        {
          access_key_id:     ENV['AWS_ACCESS_KEY'],
          secret_access_key: ENV['AWS_SECRET_KEY'],
          region:            ENV['AWS_REGION']
        }
      end

    end
  end
end
