require 'aws/broker/publishing'

module Aws
  class Broker
    class Railtie < Rails::Railtie

      initializer 'aws-broker.extend_active_record' do
        ActiveSupport.on_load(:active_record) do
          ActiveRecord::Base.send(:extend, Aws::Broker::Publishing)
        end
      end

    end
  end
end
