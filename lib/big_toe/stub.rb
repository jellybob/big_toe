module BigToe
  class Stub
    def initialize
      @invocations = {}
      @expectations = {}
    end

    def method_missing(method, *args)
      @invocations[method.to_sym] = args
      expectation_for(method.to_sym).return_value_for(args)
    end

    def has_received?(method)
      @invocations.key?(method.to_sym)
    end

    def arguments_for(method)
      @invocations[method.to_sym]
    end

    def stubs(method_map = {})
      if method_map.respond_to?(:each)
        method_map.each do |key, value|
          @expectations[key.to_sym] = Expectation.new(value)
        end
      else
        @expectations[method_map.to_sym] = Expectation.new
      end
    end

    protected
    def expectation_for(method)
      @expectations[method] || Expectation.new
    end
  end

  class Expectation
    def initialize(return_value = nil, arguments = [])
      @arguments = arguments
      @return_value = return_value
    end

    def with(*args)
      @arguments = args
      self
    end

    def returns(value)
      @return_value = value
      self
    end

    def return_value_for(arguments = [])
      if arguments == @arguments
        return @return_value
      end

      nil
    end
  end
end
