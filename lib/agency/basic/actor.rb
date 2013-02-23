require "agency/basic/actor/proxy"

module Agency
  module Basic
    module Actor

      ACTOR_KEY   = :__agency_actor__

      def self.current
        Thread.current[ACTOR_KEY]
      end

      def new(*args, &block)
        Proxy.new(allocate, *args, &block)
      end

    end
  end
end
