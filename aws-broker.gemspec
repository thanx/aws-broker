# -*- encoding: utf-8 -*-
$:.push File.expand_path('../lib', __FILE__)

Gem::Specification.new do |s|
  s.name        = 'aws-broker'
  s.version     = '0.0.9'
  s.platform    = Gem::Platform::RUBY
  s.authors     = ['Eng @ Thanx']
  s.email       = 'eng@thanx.com'
  s.homepage    = 'https://github.com/thanx/aws-broker'
  s.summary     = 'AWS Broker'
  s.description = 'Ruby pub-sub on AWS'
  s.license     = 'MIT'

  s.files       = Dir.glob('lib/**/*') + %w(README.md)
  s.require_paths = ['lib']

  s.add_dependency 'aws-sdk-sns'
  s.add_dependency 'aws-sdk-sqs'
end
