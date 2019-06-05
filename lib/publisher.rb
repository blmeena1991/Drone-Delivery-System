module Publisher
    class << self
      include Wisper::Publisher
      def broadcast(event, *args)
        publish(event, *args)
      end
    end
end
