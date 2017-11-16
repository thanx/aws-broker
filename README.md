# AWS Broker

:incoming_envelope: Ruby pub-sub on AWS

* * *

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
