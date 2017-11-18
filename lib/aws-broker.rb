require 'aws-sdk-sqs'
require 'aws-sdk-sns'
require 'aws/broker'
require 'aws/broker/railtie' if defined?(Rails)

begin
  require 'shoryuken'
  require 'shoryuken/subscriber'
rescue LoadError
end
