require 'spec_helper'
require 'securerandom'

describe Aws::Broker::Publisher do

  let(:publisher) { described_class.new(topic, message) }
  let(:topic) { 'topic' }
  let(:message) { { id: 0 } }

  before do
    Aws::Broker.config.topic_prefix = 'tpfx'
    allow(Aws::SNS::Client).to receive(:new) { sns }
  end

  after do
    Aws::Broker.config.topic_prefix = nil
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

      it 'publishes message' do
        expect(sns).to receive(:publish).with(
          topic_arn: topic_arn,
          message:   message.to_json
        )
        publisher.publish
      end

      it 'ensures topic is created' do
        expect(sns).to receive(:create_topic).with(name: 'tpfx_topic')
        publisher.publish
      end
    end
  end

end
