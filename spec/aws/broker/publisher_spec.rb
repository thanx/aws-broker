require 'spec_helper'
require 'securerandom'

describe Aws::Broker::Publisher do

  let(:publisher) { described_class.new(topic, message) }
  let(:topic) { 'topic' }
  let(:message) { { id: 0 } }

  before do
    allow(Aws::SNS::Client).to receive(:new) { sns }
  end

  let(:sns) {
    double(
      Aws::SNS::Client,
      create_topic: double(topic_arn: topic_arn),
      publish:      true
    )
  }
  let(:topic_arn) { SecureRandom.hex }

  context '#publish' do
    context '!enabled?' do
      before { Aws::Broker.config.enabled = false }

      it 'does not publish' do
        expect(sns).not_to receive(:publish)
        publisher.publish
      end
    end

    context 'enabled?' do
      before { Aws::Broker.config.enabled = true }

      it 'ensures topic is created' do
        expect(sns).to receive(:create_topic).with(name: topic)
        publisher.publish
      end

      it 'publishes message' do
        expect(sns).to receive(:publish).with(
          topic_arn: topic_arn,
          message:   message.to_json
        )
        publisher.publish
      end
    end
  end

end
