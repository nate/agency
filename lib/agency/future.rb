require "thread"

module Agency
  class Future

    class AlreadySetError < StandardError; end

    def initialize
      @mutex = Mutex.new
      @cvar  = ConditionVariable.new
    end

    def value=(v)
      @mutex.synchronize do
        raise AlreadySetError if defined?(@value)
        @value = v
      end
    end

    def value
      return @value if defined?(@value)

      @mutex.synchronize do
        @cvar.wait(@mutex) until defined?(@value)
        @value
      end
    end

  end
end
