# AWS Broker [![Gem Version](https://badge.fury.io/rb/aws-broker.svg)](https://badge.fury.io/rb/aws-broker)

:incoming_envelope: Ruby pub-sub on AWS

* * *

[![CircleCI](https://circleci.com/gh/Thanx/aws-broker.svg?style=svg)](https://circleci.com/gh/Thanx/aws-broker)

### Background

This lightweight abstraction simplifies pub-sub on AWS's SNS and SQS services.
Message processing is not part of this gem - we recommend using
[Shoryuken](https://github.com/phstc/shoryuken) in addition to this gem.

### Installation

    gem 'aws-broker'

### Usage

    Broker = Aws::Broker
    topic = 'topic'
    queue = 'queue'
    message = { id: 0 }

    # subscribe topic to specified queue
    Broker.subscribe(topic, queue)

    # subscribe topic to default queue
    #   "topic" or "prefix-topic" (see options)
    Broker.subscribe(topic)

    # publish message to topic
    Broker.publish(topic, message)

### Rails Support

Though AWS Broker does not require Rails, an ActiveRecord extension and
accompanying RSpec matcher is provided if the project is Rails. This simplifies
the process of publishing events for ActiveRecord create, update, and destroy
callbacks.

    # app/models/user.rb
    class User < ActiveRecord::Base
      publish_event :create, :update, :destroy
    end

    # spec/rails_helper.rb
    require 'aws/broker/matchers'

    # spec/models/user_spec.rb
    describe User do
      context 'publish' do
        subject { User }
        it { should publish_event(:create) }
        it { should publish_event(:update) }
        it { should publish_event(:destroy) }
      end
    end

This essentially abstracts the following:

    # app/models/user.rb
    class User < ActiveRecord::Base
      after_commit on: :create do
        Broker.publish(:user, event: :create, id: id)
      end
    end

Queues are determined automatically:

    class User            # queue :user
    class User::Facebook  # queue :user_facebook

### Configuration

#### Broker Options

Aws::Broker can be configured via the following:

    Aws::Broker.configure do |config|
      config.enabled      = false
      config.queue_prefix = 'prefix'
    end

The following options are available:

| Option         | Default | Description                                      |
|----------------|---------|--------------------------------------------------|
| `enabled`      | true    | if false, don't trigger API calls to AWS         |
| `queue_prefix` | nil     | prefix for default queue name (prefix-topic)     |

#### AWS Client

AWS Broker wraps the AWS SQS and SNS clients. All configuration is the same as
the AWS SDK. See
[Configuring the AWS SDK for Ruby](http://docs.aws.amazon.com/sdk-for-ruby/v3/developer-guide/setup-config.html)
for details.

Some supported options:

* `AWS_ACCESS_KEY_ID`, `AWS_SECRET_ACCESS_KEY`, `AWS_REGION` env variables
* shared `~/.aws/credentials` file
* IAM
* `Aws.config[:credentials]`

### Inspiration

* [propono](https://github.com/iHiD/propono)
* [shoryuken](https://github.com/phstc/shoryuken)
* [bunny](https://github.com/ruby-amqp/bunny)
