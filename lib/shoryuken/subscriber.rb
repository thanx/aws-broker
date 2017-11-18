module Shoryuken
  class Subscriber
    include Shoryuken::Worker

    class << self
      attr_reader :resource_class

      def queue=(queue)
        shoryuken_options(
          queue:       queue,
          auto_delete: true,
          body_parser: :json
        )
      end

      def resource_class=(klass)
        @resource_class = klass
      end
    end

    def perform(_, body)
      @body = body
      send(event)
    end

  private

    def resource
      @resource ||= self.class.resource_class.constantize.find(message[:id])
    end

    def event
      message[:event]
    end

    def message
      @message ||= JSON.parse(@body['Message']).symbolize_keys
    rescue JSON::ParserError
      {}
    end

  end
end
