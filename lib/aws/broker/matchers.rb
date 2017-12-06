RSpec::Matchers.define :publish_event do |event|
  match do |klass|
    filter = :"publish_event_#{event}"
    # find callback
    callback = klass._commit_callbacks.detect { |c| c.filter == filter }
    # assert existence
    expect(callback).to be
    # assert after_commit
    expect(callback.kind).to eq(:after)
    # assert after commit event type
    expect(callback.instance_variable_get(:@if)[0]).to include("[:#{event}]")
    # assert broker call is triggered
    object = klass.new
    allow(object).to receive(:id) { 0 }
    expect(Broker).to receive(:publish).with(
      klass.publish_topic,
      event: event,
      id:    0
    )
    object.send(filter)
    true
  end

  failure_message do |klass|
    "expected #{klass.to_s} to publish_event #{event}"
  end
end
