require 'spec_helper'

describe Aws::Broker do

  let(:topic) { 'topic' }
  let(:queue) { 'queue' }
  let(:message) {
    {
      id:    0,
      event: 'event'
    }
  }

  let(:publisher) { described_class::Publisher }
  let(:subscriber) { described_class::Subscriber }

  before { Aws::Broker.config.enabled = false }

  context '.publish' do
    let(:params) { [ topic, message ] }

    it 'initializes class' do
      expect(publisher).to receive(:new).with(*params).and_call_original
      described_class.publish(*params)
    end

    it 'calls publish on instance' do
      expect_any_instance_of(publisher).to receive(:publish)
      described_class.publish(*params)
    end
  end

  context '.subscribe' do
    context 'no queue specified' do
      it 'initializes class' do
        expect(subscriber).to receive(:new).with(topic).and_call_original
        described_class.subscribe(topic)
      end

      it 'calls publish on instance' do
        expect_any_instance_of(subscriber).to receive(:subscribe)
        described_class.subscribe(topic)
      end
    end

    context 'queue specified' do
      let(:params) { [ topic, queue ] }

      it 'initializes class' do
        expect(subscriber).to receive(:new).with(*params).and_call_original
        described_class.subscribe(*params)
      end

      it 'calls publish on instance' do
        expect_any_instance_of(subscriber).to receive(:subscribe)
        described_class.subscribe(*params)
      end
    end
  end

  context '.config' do
    it 'is memoized' do
      expect(described_class.config).to eq(described_class.config)
    end
  end

  context '.configure' do
    it 'yields config' do
      described_class.configure do |config|
        expect(config).to eq(described_class.config)
      end
    end
  end

end
