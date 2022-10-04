module Liza
  class TestAssertionsPart < Part
    insertion do
      # CLASS

      def self.totals
        @totals ||= {
                      todos: [],
                      passes: [],
                      fails: [],
                      errors: [],
                    }
      end

      def self._assertion_todo msg
        self.totals[:todos] << msg
      end

      def self._assertion_passed
        self.totals[:passes] << 1
      end

      def self._assertion_failed msg
        self.totals[:fails] << msg
      end

      def self._assertion_errored e
        self.totals[:errors] << e
      end

      # INSTANCE

      attr_writer :assertions

      def assertions
        @assertions ||= 0
      end

      def _inc_assertions
        self.assertions += 1
      end

      # ASSERTIONS

      def todo msg
        self.class._assertion_todo msg
        @last_result = :todo

        _assertion_log __method__, caller if _groups.empty?
      end

      def _groups
        @_groups ||= []
      end

      def group kaller: nil, **_words, &block
        block_given? || raise(ArgumentError, "No block given")

        _groups << block
        instance_exec &block
        _groups.pop

        kaller ||= caller
        _assertion_log __method__, kaller if _groups.empty?
      end

      def assert b, msg = "it should have been true", kaller: nil
        if b
          self.class._assertion_passed
          @last_result = :passed
        else
          self.class._assertion_failed msg
          @last_result = :failed
        end

        kaller ||= caller
        _assertion_log __method__, kaller if _groups.empty?

        b
      end

      def refute b, msg = "it should have been false", kaller: nil
        if b
          self.class._assertion_failed msg
          @last_result = :failed
        else
          self.class._assertion_passed
          @last_result = :passed
        end

        kaller ||= caller
        _assertion_log __method__, kaller if _groups.empty?

        b
      end

      def assert! b, msg = "it should have been true"
        critical assert b, msg, kaller: caller
      end

      def refute! b, msg = "it should have been false"
        critical refute b, msg, kaller: caller
      end

      def critical passed
        throw :critical, :critical if not passed
      end
    end
  end
end
