require 'spec_helper'

describe Aws::Broker::Naming do
  let(:naming) { described_class.new }
  let(:topic_prefix) { nil }
  let(:queue_prefix) { nil }

  before do
    Aws::Broker.config.topic_prefix = topic_prefix
    Aws::Broker.config.queue_prefix = queue_prefix
  end

  after do
    Aws::Broker.config.topic_prefix = nil
    Aws::Broker.config.queue_prefix = nil
  end

  context '#queue' do
    context 'no prefix' do
      it { expect(naming.queue('topic')).to eq('topic') }
    end

    context 'topic prefix' do
      let(:topic_prefix) { 'tpfx' }

      it { expect(naming.queue('topic')).to eq('tpfx_topic') }
    end

    context 'queue prefix' do
      let(:queue_prefix) { 'qpfx' }

      it { expect(naming.queue('topic')).to eq('qpfx-topic') }
    end

    context 'topic and queue prefix' do
      let(:topic_prefix) { 'tpfx' }
      let(:queue_prefix) { 'qpfx' }

      it { expect(naming.queue('topic')).to eq('qpfx-tpfx_topic') }
    end
  end

  context '#topic' do
    let(:topic) { 'topic' }

    context 'no prefix' do
      it { expect(naming.topic('topic')).to eq('topic') }
    end

    context 'prefix' do
      let(:topic_prefix) { 'tpfx' }

      it { expect(naming.topic('topic')).to eq('tpfx_topic') }
    end
  end

end
