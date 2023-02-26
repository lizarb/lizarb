class Liza::TestAssertionsAdvancedPart < Liza::Part
  insertion do
    
    def assert_equality a, b, msg = nil, kaller: nil
      ret = a == b

      if ret
        self.class._assertion_passed
        @last_result = :passed
      else
        self.class._assertion_failed msg
        @last_result = :failed
      end

      kaller ||= caller
      log_test_assertion __method__, kaller if _groups.empty?

      if log_test_assertion_message?
        msg ||= "#{__method__} #{a}, #{b} (== equality)"
        log_test_assertion_message ret, msg
      end

      ret
    end

    def refute_equality a, b, msg = nil, kaller: nil
      ret = a == b

      if ret
        self.class._assertion_failed msg
        @last_result = :failed
      else
        self.class._assertion_passed
        @last_result = :passed
      end

      kaller ||= caller
      log_test_assertion __method__, kaller if _groups.empty?

      if log_test_assertion_message?
        msg ||= "#{__method__} #{a}, #{b} (== equality)"
        log_test_assertion_message !ret, msg
      end

      ret
    end

    def assert_equality! a, b, msg = nil
      critical assert_equality a, b, msg, kaller: caller
    end

    def refute_equality! a, b, msg = nil
      critical refute_equality a, b, msg, kaller: caller
    end

    def assert_raises exception_klass, msg = nil, kaller: nil, &block
      raise ArgumentError, "No block given" unless block_given?

      ret = false
      begin
        yield
      rescue => e
        ret = exception_klass === e
        error = e
      end

      if ret
        self.class._assertion_passed
        @last_result = :passed
      else
        self.class._assertion_failed msg
        @last_result = :failed
      end

      kaller ||= caller
      log_test_assertion __method__, kaller if _groups.empty?

      if log_test_assertion_message?
        msg ||= "#{__method__} (#{exception_klass}) #{error.inspect}"
        log_test_assertion_message ret, msg
      end

      ret
    end

    def refute_raises exception_klass, msg = nil, kaller: nil, &block
      raise ArgumentError, "No block given" unless block_given?

      ret = false
      begin
        yield
      rescue => e
        ret = !exception_klass === e
        error = e
      end

      if ret
        self.class._assertion_failed msg
        @last_result = :failed
      else
        self.class._assertion_passed
        @last_result = :passed
      end

      kaller ||= caller
      log_test_assertion __method__, kaller if _groups.empty?

      if log_test_assertion_message?
        msg ||= "#{__method__} (#{exception_klass}) #{error.inspect}"
        log_test_assertion_message !ret, msg
      end

      ret
    end

    def assert_raises! e, msg = nil
      critical assert_raises e, msg, kaller: caller
    end

    def refute_raises! e, msg = nil
      critical refute_raises e, msg, kaller: caller
    end

  end
end
