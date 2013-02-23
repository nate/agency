require "spec_helper"

describe Agency do

  class Foo
    extend Agency::Basic::Actor

    def initialize(ordering_array)
      @ordering_array = ordering_array
    end

    def bar
      @ordering_array << 1
      sleep 0.2
      @ordering_array << 2
      sleep 0.2
      @ordering_array << 3
    end
  end

  it "should do some things in a specific order" do
    ordering_array = []

    Foo.new(ordering_array).send(:bar)

    sleep 0.1
    ordering_array << 4
    sleep 0.2
    ordering_array << 5
    sleep 0.2
    ordering_array << 6

    ordering_array.should == [1,4,2,5,3,6]
  end

end
