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
              self.class.publish_topic,
              event:      event,
              id:         id,
              attributes: attributes
            )
          end
          after_commit method_name, on: event
        end
      end

      def publish_topic
        if defined?(@@publish_topic)
          @@publish_topic
        else
          to_s.underscore.tr('/', '_')
        end
      end

      # optional override of default topic
      def publish_topic=(topic)
        @@publish_topic = topic
      end

    end
  end
end
