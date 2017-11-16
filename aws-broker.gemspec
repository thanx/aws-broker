# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)
require "aws/broker/constants"

Gem::Specification.new do |s|
  s.name        = 'aws-broker'
  s.version     = AWS::Broker::VERSION
  s.platform    = Gem::Platform::RUBY
  s.authors     = ['Eng @ Thanx']
  s.email       = 'eng@thanx.com'
  s.homepage    = 'https://github.com/thanx/aws-broker'
  s.summary     = 'AWS Broker'
  s.description = 'Lightweight Ruby pub-sub abstraction on AWS'
  s.license     = 'MIT'

  s.files       = Dir.glob("lib/**/*") + %w(README.md)
  s.require_paths = ['lib']

  s.add_dependency 'aws-sdk-sns'
  s.add_dependency 'aws-sdk-sqs'
end
