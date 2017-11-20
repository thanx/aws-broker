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

### Basic Usage

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

### Rails Usage

Though AWS Broker does not require Rails, an ActiveRecord extension and
accompanying RSpec matcher is provided if the project is Rails. This simplifies
the process of publishing events for ActiveRecord create, update, and destroy
callbacks.

    ## Publishing

    # app/models/user.rb
    class User < ActiveRecord::Base
      publish_event :create, :update, :destroy
    end

    ## Subscribing

    # app/subscribers/user_subscriber.rb
    class UserSubscriber < Shoryuken::Subscriber
      self.resource_class = 'User'

      def create;  ... end

      def update;  ... end

      def destroy; ... end
    end

    ## Testing

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

### Usage Details

See the [wiki](https://github.com/Thanx/aws-broker/wiki) for an in-depth
overview of usage and configuration options.

### Inspiration

* [propono](https://github.com/iHiD/propono)
* [shoryuken](https://github.com/phstc/shoryuken)
* [bunny](https://github.com/ruby-amqp/bunny)
