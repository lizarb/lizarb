class Liza::TestAssertionsAdvancedPart < Liza::Part
  insertion do

    section :assertion_equality

    ##
    # Asserts that +a+ and +b+ are equal.
    #
    # Passes if +a == b+, fails otherwise. Optionally takes a custom failure message.
    #
    # @param a [Object] The first object to compare.
    # @param b [Object] The second object to compare.
    # @param msg [String, nil] An optional message to display on failure.
    # @param kaller [Array, nil] Optional caller information.
    # @return [Boolean] True if the assertion passes.
    #
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
        msg ||= "#{__method__} #{a.inspect}, #{b.inspect} (== equality)"
        log_test_assertion_message ret, msg
      end

      ret
    end

    ##
    # Asserts that +a+ and +b+ are *not* equal.
    #
    # Passes if +a != b+, fails otherwise. Optionally takes a custom failure message.
    #
    # @param a [Object] The first object to compare.
    # @param b [Object] The second object to compare.
    # @param msg [String, nil] An optional message to display on failure.
    # @param kaller [Array, nil] Optional caller information.
    # @return [Boolean] True if the assertion passes.
    #
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

    ##
    # Asserts that +a+ and +b+ are equal, stopping execution on failure.
    #
    # Calls {#assert_equality} and halts if the assertion fails.
    #
    # @param a [Object] The first object to compare.
    # @param b [Object] The second object to compare.
    # @param msg [String, nil] An optional message to display on failure.
    # @return [void]
    #
    def assert_equality! a, b, msg = nil
      critical assert_equality a, b, msg, kaller: caller
    end

    ##
    # Asserts that +a+ and +b+ are *not* equal, stopping execution on failure.
    #
    # Calls {#refute_equality} and halts if the assertion fails.
    #
    # @param a [Object] The first object to compare.
    # @param b [Object] The second object to compare.
    # @param msg [String, nil] An optional message to display on failure.
    # @return [void]
    #
    def refute_equality! a, b, msg = nil
      critical refute_equality a, b, msg, kaller: caller
    end

    section :assertion_raises

    ##
    # Asserts that the given block raises an exception of the specified class.
    #
    # Fails if the block does not raise an exception or raises an unexpected type.
    #
    # @param exception_klass [Class] The class of the exception expected.
    # @param msg [String, nil] An optional message to display on failure.
    # @param kaller [Array, nil] Optional caller information.
    # @yield The block to execute.
    # @return [Boolean] True if the assertion passes.
    #
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

    ##
    # Asserts that the given block does *not* raise an exception of the specified class.
    #
    # Passes if no exception or an unrelated exception is raised.
    #
    # @param exception_klass [Class] The class of the exception that should *not* be raised.
    # @param msg [String, nil] An optional message to display on failure.
    # @param kaller [Array, nil] Optional caller information.
    # @yield The block to execute.
    # @return [Boolean] True if the assertion passes.
    #
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

    ##
    # Asserts that the given block raises an exception, stopping execution on failure.
    #
    # Calls {#assert_raises} and halts if the assertion fails.
    #
    # @param e [Class] The class of the exception expected.
    # @param msg [String, nil] An optional message to display on failure.
    # @return [void]
    #
    def assert_raises! e, msg = nil
      critical assert_raises e, msg, kaller: caller
    end

    ##
    # Asserts that the given block does *not* raise an exception, stopping execution on failure.
    #
    # Calls {#refute_raises} and halts if the assertion fails.
    #
    # @param e [Class] The class of the exception that should *not* be raised.
    # @param msg [String, nil] An optional message to display on failure.
    # @return [void]
    #
    def refute_raises! e, msg = nil
      critical refute_raises e, msg, kaller: caller
    end

  end
end
