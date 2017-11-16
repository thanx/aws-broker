require 'spec_helper'

describe Aws::Broker do

  let(:topic) { 'topic' }
  let(:message) {
    {
      id:    0,
      event: 'event'
    }
  }

  before do
    described_class.configure do |config|
      config.enabled = false
    end
  end

  context '.publish' do
    it 'initializes class' do
      expect(
        described_class::Publisher
      ).to receive(:new).with(
        topic, message
      ).and_call_original
      described_class.publish(topic, message)
    end

    it 'calls publish on instance' do
      expect_any_instance_of(
        described_class::Publisher
      ).to receive(:publish)
      described_class.publish(topic, message)
    end
  end

  context '.subscribe' do
    it 'initializes class' do
      expect(described_class::Subscriber).to receive(:new).with(
        topic
      ).and_call_original
      described_class.subscribe(topic)
    end

    it 'calls publish on instance' do
      expect_any_instance_of(
        described_class::Subscriber
      ).to receive(:subscribe)
      described_class.subscribe(topic)
    end
  end

end
