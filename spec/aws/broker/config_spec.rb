require 'spec_helper'

describe Aws::Broker::Config do

  subject { described_class.new }

  it { should have_attr_accessor(:enabled) }
  it { should have_attr_accessor(:queue_prefix) }
  it { should have_attr_accessor(:topic_prefix) }
  it { should have_attr_accessor(:sns) }
  it { should have_attr_accessor(:sqs) }
  it { expect(subject.method(:enabled?)).to eq(subject.method(:enabled)) }

end
