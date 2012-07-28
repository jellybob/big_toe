# Big Toe
## A Friendly Stubbing Framework

Big Toe is designed to provide stubbing and expectations in a manner which still supports
testing with assertions after a common setup method, like so:

    require 'minitest/autorun'
    require 'big_toe'

    describe "A stub" do
      before do
        @thing = BigToe::Stub.new
      end

      it "knows when it has received a method call" do
        @thing.foo

        assert @thing.has_received?(:foo)
      end

      it "knows what arguments were passed" do
        @thing.foo("bar")

        assert_equal "bar", @thing.arguments_for(:foo).first
      end

      it "can stub methods with a return value" do
        @thing.stubs(:foo => "bar")

        assert_equal "bar", @thing.foo
      end

      it "can stub methods for specific arguments" do
        @thing.stubs(:foo).with("bar").returns("baz")

        assert_equal "baz", @thing.foo("bar")
        assert_nil @thing.foo("other")
      end
    end

## Wrapping Objects

Stubs can also be passed an object in their constructor, which will receive any methods which
have not been overridden by the stub itself:

    require 'minitest/autorun'
    require 'big_toe'

    class ExampleObject
      def foo
        return "bar"
      end
    end

    describe "A wrapper stub" do
      before do
        @thing = BigToe::Stub.new(ExampleObject.new)
      end

      it "passes unstubbed calls through to the object" do
        assert_equal "bar", @thing.foo
      end

      it "can still stub things" do
        @thing.stubs(:foo => "baz")
        assert_equal "baz", @thing.foo
      end

      it "records invocations of wrapped methods" do
        @thing.foo
        assert @thing.has_received?(:foo)
      end
    end
