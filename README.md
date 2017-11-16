# AWS Broker [![Gem Version](https://badge.fury.io/rb/aws-broker.svg)](https://badge.fury.io/rb/aws-broker)

:incoming_envelope: Ruby pub-sub on AWS

* * *

[![CircleCI](https://circleci.com/gh/Thanx/aws-broker.svg?style=svg)](https://circleci.com/gh/Thanx/aws-broker)

### Background

This lightweight abstraction simplifies pub-sub on AWS's SNS and SQS services.
Message processing is not part of this gem - we recommend using
[Shoryuken](https://github.com/phstc/shoryuken) in addition to this gem.

### Usage

Usage:

    Broker = Aws::Broker
    topic = 'topic'
    queue = 'queue'
    message = { id: 0 }
    Broker.subscribe(topic, queue)
    Broker.publish(topic, message)

### Inspiration

* [propono](https://github.com/iHiD/propono)
* [shoryuken](https://github.com/phstc/shoryuken)
* [bunny](https://github.com/ruby-amqp/bunny)
