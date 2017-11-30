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
              @publish_topic || self.class.to_s.underscore.tr('/', '_'),
              event: event,
              id:    id
            )
          end
          after_commit method_name, on: event
        end
      end

      # optional override of default topic
      def publish_topic=(topic)
        @publish_topic = topic
      end

    end
  end
end
