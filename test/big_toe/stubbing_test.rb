require 'minitest/autorun'
require 'big_toe/stub'

describe BigToe::Stub do
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
