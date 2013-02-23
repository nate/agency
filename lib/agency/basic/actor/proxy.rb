require "agency/future"
require "thread"

module Agency
  module Basic
    module Actor
      class Proxy

        KILL_SIGNAL = :__agency_kill__

        def initialize(instance, *args, &block)
          @instance = instance
          @kill     = false
          @mailbox  = Queue.new

          @mailbox << [:initialize, args, block]

          @thread = Thread.new do
            Thread.current[ACTOR_KEY] = self

            until @kill
              method, args, block, future = @mailbox.pop
              break if method == KILL_SIGNAL
              return_value = @instance.__send__(method, *args, &block)
              future.value = return_value if future
            end
          end
        end

        def kill
          @kill = true
          send(KILL_SIGNAL)
        end

        def alive?
          @thread.alive?
        end

        def send(method, *args, &block)
          @mailbox << [method, args, block]
        end

        def send_with_future(method, *args, &block)
          future = Future.new
          @mailbox << [method, args, block, future]
          future
        end

      end
    end
  end
end
