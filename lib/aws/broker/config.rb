module Aws
  class Broker
    class Config

      attr_accessor :enabled, :queue_prefix, :topic_prefix, :sqs, :sns
      alias_method :enabled?, :enabled

      def initialize
        self.enabled      = true
        self.queue_prefix = nil
        self.topic_prefix = nil
      end

      def sqs
        @sqs ||= Aws::SQS::Client.new
      end

      def sns
        @sns ||= Aws::SNS::Client.new
      end
    end
  end
end
