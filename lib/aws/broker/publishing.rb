module Aws
  class Broker
    module Publishing

      # only :create, :update, :destroy
      def publish_event(*events)
        events.each do |event|
          event = event.to_sym
          unless [:create, :update, :destroy].include?(event)
            raise "Invalid publish event #{event}"
          end
          method_name = :"publish_event_#{event}"
          define_method method_name do
            Broker.publish(
              self.class.to_s.underscore.tr('/', '_'),
              event: event,
              id:    id
            )
          end
          after_commit method_name, on: event
        end
      end

    end
  end
end
