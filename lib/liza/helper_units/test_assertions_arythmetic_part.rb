class Liza::TestAssertionsArythmeticPart < Liza::Part
  insertion do

    ##
    # Asserts that +a+ is greater than +b+.
    #
    # Passes if +a > b+, fails otherwise. Optionally takes a custom failure message.
    #
    # @param a [Comparable] The first object to compare.
    # @param b [Comparable] The second object to compare.
    # @param msg [String, nil] An optional message to display on failure.
    # @param kaller [Array, nil] Optional caller information.
    # @return [Boolean] True if the assertion passes.
    def assert_gt a, b, msg = nil, kaller: nil
      raise "First argument is not Comparable (#{a.class})" unless a.is_a?(Comparable)
      raise "Second argument is not Comparable (#{b.class})" unless b.is_a?(Comparable)
      ret = a > b

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
        msg ||= "#{__method__} #{a.inspect}, #{b.inspect} (> greater than)"
        log_test_assertion_message ret, msg
      end

      ret
    end

    ##
    # Asserts that +a+ is not greater than +b+.
    #
    # Passes if +a <= b+, fails otherwise. Optionally takes a custom failure message.
    #
    # @param a [Comparable] The first object to compare.
    # @param b [Comparable] The second object to compare.
    # @param msg [String, nil] An optional message to display on failure.
    # @param kaller [Array, nil] Optional caller information.
    # @return [Boolean] True if the assertion passes.
    def refute_gt a, b, msg = nil, kaller: nil
      raise "First argument is not Comparable (#{a.class})" unless a.is_a?(Comparable)
      raise "Second argument is not Comparable (#{b.class})" unless b.is_a?(Comparable)
      ret = a <= b

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
      msg ||= "#{__method__} #{a.inspect}, #{b.inspect} (<= not greater than)"
      log_test_assertion_message ret, msg
      end

      ret
    end

    ##
    # Asserts that +a+ is lesser than +b+.
    #
    # Passes if +a > b+, fails otherwise. Optionally takes a custom failure message.
    #
    # @param a [Comparable] The first object to compare.
    # @param b [Comparable] The second object to compare.
    # @param msg [String, nil] An optional message to display on failure.
    # @param kaller [Array, nil] Optional caller information.
    # @return [Boolean] True if the assertion passes.
    def assert_lt a, b, msg = nil, kaller: nil
      raise "First argument is not Comparable (#{a.class})" unless a.is_a?(Comparable)
      raise "Second argument is not Comparable (#{b.class})" unless b.is_a?(Comparable)
      ret = a < b

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
        msg ||= "#{__method__} #{a.inspect}, #{b.inspect} (< lesser than)"
        log_test_assertion_message ret, msg
      end

      ret
    end

    ##
    # Asserts that +a+ is not lesser than +b+.
    #
    # Passes if +a >= b+, fails otherwise. Optionally takes a custom failure message.
    #
    # @param a [Comparable] The first object to compare.
    # @param b [Comparable] The second object to compare.
    # @param msg [String, nil] An optional message to display on failure.
    # @param kaller [Array, nil] Optional caller information.
    # @return [Boolean] True if the assertion passes.
    def refute_lt a, b, msg = nil, kaller: nil
      raise "First argument is not Comparable (#{a.class})" unless a.is_a?(Comparable)
      raise "Second argument is not Comparable (#{b.class})" unless b.is_a?(Comparable)
      ret = a >= b

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
      msg ||= "#{__method__} #{a.inspect}, #{b.inspect} (>= not lesser than)"
      log_test_assertion_message ret, msg
      end

      ret
    end

  end
end
