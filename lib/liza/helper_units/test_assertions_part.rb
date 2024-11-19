class Liza::TestAssertionsPart < Liza::Part
  insertion do
    section :assertion_totals

    # Returns or initializes a hash that tracks the totals for various test outcomes.
    #
    # @return [Hash] a hash containing arrays for `:errors`, `:todos`, `:fails`, and `:passes`.
    def self.totals
      @totals ||= {
                    errors: [],
                    todos: [],
                    fails: [],
                    passes: [],
                  }
    end

    # Records a "to-do" assertion message.
    #
    # @param msg [String] the message associated with the "to-do" assertion
    def self._assertion_todo msg
      self.totals[:todos] << msg
    end

    # Records a successful assertion.
    def self._assertion_passed
      self.totals[:passes] << 1
    end

    # Records a failed assertion with an associated message.
    #
    # @param msg [String] the failure message.
    def self._assertion_failed msg
      self.totals[:fails] << msg
    end

    # Records an assertion that resulted in an error.
    #
    # @param e [Exception] the exception object related to the error.
    def self._assertion_errored e
      self.totals[:errors] << e
    end

    # Sets the count of assertions for the instance.
    #
    # @param value [Integer] the number of assertions.
    attr_writer :assertions

    # Returns the number of assertions made by the instance, initializing to 0 if not set.
    #
    # @return [Integer] the number of assertions.
    def assertions
      @assertions ||= 0
    end

    # Increments the count of assertions by one.
    def _inc_assertions
      self.assertions += 1
    end

    section :assertion

    # Marks a test as a "to-do" with an associated message.
    #
    # @param msg [String] the "to-do" message.
    def todo msg
      self.class._assertion_todo msg
      @last_result = :todo

      log_test_assertion __method__, caller if _groups.empty?
    end

    # Provides or initializes an array to manage test group contexts.
    #
    # @return [Array] an array of group blocks.
    def _groups
      @_groups ||= []
    end

    # Executes a block within a test group context.
    #
    # @param kaller [String] (optional) the caller context for logging.
    # @yield [block] the block of code representing the group.
    # @raise [ArgumentError] if no block is provided.
    def group kaller: nil, **_words, &block
      block_given? || raise(ArgumentError, "No block given")

      _groups << block
      instance_exec(&block)
      _groups.pop

      kaller ||= caller
      log_test_assertion __method__, kaller if _groups.empty?
    end

    section :assertion_basic

    # Asserts that a condition is true.
    #
    # @param b [Boolean] the condition to check.
    # @param msg [String] (optional) the failure message if the assertion fails.
    # @param kaller [String] (optional) the caller context for logging.
    # @return [Boolean] the result of the assertion.
    def assert b, msg = "it should have been true", kaller: nil
      if b
        self.class._assertion_passed
        @last_result = :passed
      else
        self.class._assertion_failed msg
        @last_result = :failed
      end

      kaller ||= caller
      log_test_assertion __method__, kaller if _groups.empty?

      b
    end

    # Asserts that a condition is false.
    #
    # @param b [Boolean] the condition to check.
    # @param msg [String] (optional) the failure message if the assertion fails.
    # @param kaller [String] (optional) the caller context for logging.
    # @return [Boolean] the result of the assertion.
    def refute b, msg = "it should have been false", kaller: nil
      if b
        self.class._assertion_failed msg
        @last_result = :failed
      else
        self.class._assertion_passed
        @last_result = :passed
      end

      kaller ||= caller
      log_test_assertion __method__, kaller if _groups.empty?

      b
    end

    # Performs an assertion and stops the test execution if it fails.
    #
    # @param b [Boolean] the condition to check.
    # @param msg [String] (optional) the failure message if the assertion fails.
    def assert! b, msg = "it should have been true"
      critical assert b, msg, kaller: caller
    end

    # Performs a refutation and stops the test execution if it fails.
    #
    # @param b [Boolean] the condition to check.
    # @param msg [String] (optional) the failure message if the refutation fails.
    def refute! b, msg = "it should have been false"
      critical refute b, msg, kaller: caller
    end

    # Halt test execution if a condition fails by throwing :critical symbol.
    #
    # @param passed [Boolean] the result of the assertion or refutation.
    def critical passed
      throw :critical, :critical if not passed
    end

  end
end
