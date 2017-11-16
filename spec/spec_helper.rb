require 'aws-broker'
require 'pry'

RSpec.configure do |config|
  config.expect_with :rspec do |expectations|
    expectations.include_chain_clauses_in_custom_matcher_descriptions = true
  end

  config.mock_with :rspec do |mocks|
    mocks.verify_partial_doubles = true
  end

  config.shared_context_metadata_behavior = :apply_to_host_groups

  config.profile_examples = 10
  config.order = :random
end

RSpec::Matchers.define :have_attr_accessor do |field|
  match do |object|
    object.respond_to?(field) && object.respond_to?("#{field}=")
  end

  failure_message do |object|
    "expected attr_accessor for #{field} on #{object}"
  end

  failure_message_when_negated do |object|
    "expected attr_accessor for #{field} not to be defined on #{object}"
  end

  description do
    'checks to see if there is an attr accessor on the supplied object'
  end
end
