require 'spec_helper'
require 'securerandom'

describe Aws::Broker::Subscriber do

  let(:subscriber) { described_class.new(*params) }
  let(:params) { [ topic, queue ] }
  let(:topic) { 'topic' }
  let(:queue) { 'queue' }

  before do
    allow(Aws::SNS::Client).to receive(:new) { sns }
    allow(Aws::SQS::Client).to receive(:new) { sqs }
  end

  let(:sns) {
    double(
      Aws::SNS::Client,
      create_topic: double(topic_arn: topic_arn),
      subscribe: true
    )
  }
  let(:topic_arn) { SecureRandom.hex }

  let(:sqs) {
    double(
      Aws::SQS::Client,
      create_queue:         double(queue_url: queue_url),
      get_queue_attributes: double(attributes: { 'QueueArn' => queue_arn }),
      set_queue_attributes: true
    )
  }
  let(:queue_url) { 'http://sqs.us-east-2.amazonaws.com/123456789012/queue' }
  let(:queue_arn) { SecureRandom.hex }

  context '#subscribe' do
    context '!enabled?' do
      before { Aws::Broker.config.enabled = false }

      it 'does not publish' do
        expect(sns).not_to receive(:subscribe)
        subscriber.subscribe
      end
    end

    context 'enabled?' do
      before { Aws::Broker.config.enabled = true }

      context 'queue' do
        it 'creates queue' do
          expect(sqs).to receive(:create_queue).with(queue_name: queue)
          subscriber.subscribe
        end

        context 'default queue' do
          let(:params) { [ topic ] }

          it 'uses topic name' do
            expect(sqs).to receive(:create_queue).with(queue_name: topic)
            subscriber.subscribe
          end

          context 'queue_prefix config' do
            before { Aws::Broker.config.queue_prefix = 'prefix' }
            after  { Aws::Broker.config.queue_prefix = nil }

            it 'uses queue prefix' do
              expect(sqs).to receive(:create_queue).with(
                queue_name: 'prefix-topic'
              )
              subscriber.subscribe
            end
          end

          context 'topic_prefix config' do
            before { Aws::Broker.config.topic_prefix = 'prefix' }
            after  { Aws::Broker.config.topic_prefix = nil }

            it 'uses topic prefix' do
              expect(sqs).to receive(:create_queue).with(
                queue_name: 'prefix_topic'
              )
              subscriber.subscribe
            end
          end

          context 'both queue and topic prefix config' do
            before do
              Aws::Broker.config.queue_prefix = 'qpfx'
              Aws::Broker.config.topic_prefix = 'tpfx'
            end
            after do
              Aws::Broker.config.queue_prefix = nil
              Aws::Broker.config.topic_prefix = nil
            end

            it 'uses topic prefix' do
              expect(sqs).to receive(:create_queue).with(
                queue_name: 'qpfx-tpfx_topic'
              )
              subscriber.subscribe
            end
          end
        end
      end

      context 'topic' do
        it 'creates topic' do
          expect(sns).to receive(:create_topic).with(name: topic)
          subscriber.subscribe
        end

        context 'topic_prefix config' do
          before { Aws::Broker.config.topic_prefix = 'prefix' }
          after  { Aws::Broker.config.topic_prefix = nil }

          it 'ensures prefixed topic is created' do
            expect(sns).to receive(:create_topic).with(name: 'prefix_topic')
            subscriber.subscribe
          end
        end
      end

      it 'subscribes' do
        expect(sns).to receive(:subscribe).with(
          topic_arn: topic_arn,
          protocol:  'sqs',
          endpoint:  queue_arn
        )
        subscriber.subscribe
      end

      it 'sets queue policy' do
        allow(subscriber).to receive(:policy) { 'policy' }
        expect(sqs).to receive(:set_queue_attributes).with(
          queue_url:  queue_url,
          attributes: { 'Policy': 'policy' }
        )
        subscriber.subscribe
      end

      context 'queue policy' do
        let(:policy) { JSON.parse(subscriber.send(:policy)) }

        before { subscriber.subscribe }

        it 'sets id' do
          expect(
            policy['Id']
          ).to eq(
            "#{queue_arn}/SQSDefaultPolicy"
          )
        end

        it 'sets sid' do
          expect(
            policy['Statement'][0]['Sid']
          ).to eq(
            "#{queue_arn}-Sid"
          )
        end

        it 'sets resource' do
          expect(
            policy['Statement'][0]['Resource']
          ).to eq(
            queue_arn
          )
        end

        it 'sets source arn' do
          expect(
            policy['Statement'][0]['Condition']['StringEquals']['aws:SourceArn']
          ).to eq(
            topic_arn
          )
        end
      end
    end
  end

end
