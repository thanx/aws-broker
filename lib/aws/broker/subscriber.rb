require 'aws/broker/base'

module Aws
  class Broker
    class Subscriber < Base

      def initialize(topic, queue=nil)
        @topic = topic
        @queue = queue || queue_name
      end

      def subscribe
        return unless enabled?
        create_queue
        find_queue_arn
        create_topic
        sns.subscribe(
          topic_arn: @topic_arn,
          protocol:  'sqs',
          endpoint:  @queue_arn
        )
        set_queue_policy
      end

    private

      def queue_name
        if config.queue_prefix
          "#{config.queue_prefix}-#{topic_name}"
        else
          topic_name
        end
      end

      def create_queue
        @queue_url = sqs.create_queue(
          queue_name: @queue
        ).queue_url
      end

      def find_queue_arn
        @queue_arn = sqs.get_queue_attributes(
          queue_url:       @queue_url,
          attribute_names: ['QueueArn']
        ).attributes['QueueArn']
      end

      def set_queue_policy
        sqs.set_queue_attributes(
          queue_url:  @queue_url,
          attributes: { 'Policy': policy }
        )
      end

      def policy
        <<-POLICY
          {
            "Version": "2008-10-17",
            "Id": "#{@queue_arn}/SQSDefaultPolicy",
            "Statement": [
              {
                "Sid": "#{@queue_arn}-Sid",
                "Effect": "Allow",
                "Principal": {
                  "AWS": "*"
                },
                "Action": "SQS:*",
                "Resource": "#{@queue_arn}",
                "Condition": {
                  "StringEquals": {
                    "aws:SourceArn": "#{@topic_arn}"
                  }
                }
              }
            ]
          }
        POLICY
      end

      def sqs
        @sqs ||= Aws::SQS::Client.new
      end

    end
  end
end
