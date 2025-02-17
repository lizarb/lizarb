class Liza::Test < Liza::Unit

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

  section :no_raise

  ##
  # Asserts that no exception is raised when executing the given block.
  #
  # Passes if the block executes without raising any exception.
  #
  # @param msg [String, nil] An optional message to display on failure.
  # @param kaller [Array, nil] Optional caller information.
  # @yield The block to execute.
  # @return [Boolean] True if the assertion passes.
  #
  def assert_no_raise(msg = nil, kaller: nil, &block)
    raise ArgumentError, "No block given" unless block_given?

    ret = true
    begin
      yield
    rescue Exception => e
      ret = false
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
      msg ||= "#{__method__} - Expected no exception, got #{error.inspect}" unless ret
      log_test_assertion_message ret, msg
    end

    ret
  end

  ##
  # Asserts that no exception is raised when executing the given block, stopping execution on failure.
  #
  # Calls {#assert_no_raise} and halts if an exception is raised.
  #
  # @param msg [String, nil] An optional message to display on failure.
  # @yield The block to execute.
  # @return [void]
  #
  def assert_no_raise!(msg = nil, &block)
    critical assert_no_raise(msg, kaller: caller, &block)
  end

  ##
  # Refutes that no exception is raised when executing the given block.
  #
  # Fails if the block executes without raising an exception.
  #
  # @param msg [String, nil] An optional message to display on failure.
  # @param kaller [Array, nil] Optional caller information.
  # @yield The block to execute.
  # @return [Boolean] True if the assertion fails (i.e., an exception *is* raised).
  #
  def refute_no_raise(msg = nil, kaller: nil, &block)
    raise ArgumentError, "No block given" unless block_given?

    ret = false
    begin
      yield
      ret = true
    rescue Exception
      ret = false
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
      msg ||= "#{__method__} - Expected an exception to be raised, but none occurred" if ret
      log_test_assertion_message !ret, msg
    end

    ret
  end

  ##
  # Refutes that no exception is raised when executing the given block, stopping execution on success.
  #
  # Calls {#refute_no_raise} and halts if no exception is raised.
  #
  # @param msg [String, nil] An optional message to display on failure.
  # @yield The block to execute.
  # @return [void]
  #
  def refute_no_raise!(msg = nil, &block)
    critical refute_no_raise(msg, kaller: caller, &block)
  end

  section :assertions_arythmetic

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

  section :dsl

  def self.call class_index, class_count
    counter_class = "#{class_index.to_s.rjust 3, "0"}/#{class_count.to_s.rjust 3, "0"}"

    log stick :bold, :white, "+ #{counter_class} #{self} class"

    array = [test_tree]
    while array.any?
      node = array.pop
      i = 0

      node.tests.each do |test_words, test_block|
        counter_instance = "#{(i+=1).to_s.rjust 2, '0'}/#{node.tests.size.to_s.rjust 2, '0'}"
        label = test_words.to_a.flatten.join(" ")[0..25]

        log "  #{ counter_class } #{ counter_instance } #{ label.ljust(27)} #{_log_test_block test_block}"

        log_test_building node, test_block if log_test_building?
        
        instance = new test_words, node.before_stack, node.after_stack, &test_block
        instance.call
      end

      array.concat node.children
    end

  end

  attr_reader :test_words

  def initialize test_words, before_stack, after_stack, &test_block
    @test_words, @before_stack, @after_stack, @test_block = test_words, before_stack, after_stack, test_block
  end

  def call
    catch :critical do
      @before_stack.each do |stack|
        log "               calling stacked before blocks #{stack.map { |bl| _log_test_block bl }}" if log_test_building?
        stack.each do |bl|
          log_test_call "B&", &bl if log_test_call_block?
          instance_exec(&bl)
        end
      end

      bl = @test_block
      log "                         calling test block #{_log_test_block bl}" if log_test_building?
      log_test_call "T&", &bl if log_test_call_block?
      instance_exec(&bl)

      @after_stack.each do |stack|
        log "                calling stacked after blocks #{stack.map { |bl| _log_test_block bl }}" if log_test_building?
        stack.each do |bl|
          log_test_call "A&", &bl if log_test_call_block?
          instance_exec(&bl)
        end
      end
    end
  rescue Exception => e
    self.class._assertion_errored e
    log_test_call_rescue e
  ensure
    puts
  end

  section :log


  LOG_BUILDING = false
  LOG_ASSERTION = true
  LOG_ASSERTION_MESSAGE = true
  LOG_CALL_BLOCK = true

  def self.division
    subject_class.division
  rescue
    Liza::Controller
  end

  def division
    self.class.division
  end

  def self.log_test_building?
    LOG_BUILDING
  end

  def log_test_building?
    self.class.log_test_building?
  end

  def log_test_assertion?
    LOG_ASSERTION
  end

  def log_test_assertion_message?
    LOG_ASSERTION_MESSAGE
  end

  def log_test_call_block?
    LOG_CALL_BLOCK
  end

  def log_test_call_rescue e
    prefix = stick :light_yellow, "error"

    kaller = e.backtrace

    source_location = _caller_line_split(kaller[0])[0]
    source_location = source_location.gsub("#{App.root}/", "")

    log "                #{prefix} #{e.class.to_s.ljust 20} #{source_location}"

    puts stick :light_red, "Exception!"
    puts stick :light_red, e.class.to_s
    puts stick :light_red, e.message
    puts
    puts stick :light_red, e.backtrace.join("\n")
  end

  def self.log_test_building node, test_block
    log stick :red, :white, :b, "                         the building blocks are"

    node.before_stack.each do |stack|
      stack.each do |bl|
        log stick :red, :white, :b, "                               before block #{_log_test_block bl}"
      end
    end
    
    log stick :red, :white, :b, "                                 test block #{_log_test_block test_block}"

    node.after_stack.each do |stack|
      stack.each do |bl|
        log stick :red, :white, :b, "                                after block #{_log_test_block bl}"
      end
    end
  end

  def log_test_call prefix, &block
    source_location = block.source_location.join(":").gsub("#{App.root}/", "")
    source_location = source_location[0..-1]
    log "          #{prefix}                                #{source_location}"
  end

  def log_test_assertion method_name, kaller
    _inc_assertions
    prefix = "#{assertions.to_s.rjust 2, "0"} #{_log_test_assertion_tag method_name}"

    source_location = _caller_line_split(kaller[0])[0]
    source_location = source_location.gsub("#{App.root}/", "")

    log "             #{prefix} #{source_location}" if log_test_assertion?
  end

  def _log_test_assertion_tag method_name
    "#{log_test_assertion_result} #{stick :bold, :white, method_name.to_s.ljust(20)}"
  end

  def self._log_test_block test_block
    test_block.source_location.join(":").gsub("#{App.root}/", "")
  end

  def _log_test_block test_block
    self.class._log_test_block test_block
  end

  def log_test_assertion_result
    case @last_result
    when :todo
      (stick "  todo", :light_blue).to_s
    when :passed
      (stick "passed", :light_green).to_s
    when :failed
      (stick "failed", :light_red).to_s
    else
      raise "Unknown result: #{@last_result}"
    end
  end

  def log_test_assertion_message b, msg
    if b
      log stick :light_green, "                passed #{msg}"
    else
      log stick :light_red, "                failed #{msg}"
    end
  end

  def _caller_line_split s
    x = s.split ":in `"
    x[1] = x[1][0..-2]
    x
  end if Lizarb.ruby_version < "3.4"

  def _caller_line_split s
    x = s.split ":in '"
    x[1] = x[1][0..-2]
    x
  end if Lizarb.ruby_version >= "3.4"

  section :subject

  def self.subject_class
    @subject_class ||=
      if first_namespace == "Liza"
        Liza.const_get last_namespace[0..-5]
      else
        Object.const_get name[0..-5]
      end
  end

  def subject_class
    self.class.subject_class
  end

  def subject
    @subject ||= subject_class.new
  end

  def self.system
    subject_class.system
  rescue
    System
  end

  def system
    self.class.system
  end

  section :tree

  @before_stack = []
  @after_stack = []
  
  def self.before_stack; @before_stack ||= superclass.before_stack.dup end
  def self.after_stack;  @after_stack  ||= superclass.after_stack.dup end
  
  def self.test_node; @test_node ||= test_tree end
  # def self.test_tree; @test_tree ||= Liza::TestTreePart.new nil, before_stack, after_stack end
  def self.test_tree; @test_tree ||= Tree.new nil, before_stack, after_stack end
  
  #

  def self.group *words, &block
    raise ArgumentError, "No block given" unless block_given?
    previous = test_node
    @test_node = test_node.branch_out words
    instance_exec(&block)
    @test_node = previous
  end

  def self.test *words, &block
    raise ArgumentError, "No block given" unless block_given?
    test_node.add_test words, &block
  end

  def self.before &block
    raise ArgumentError, "No block given" unless block_given?
    test_node.add_before(&block)
  end

  def self.after &block
    raise ArgumentError, "No block given" unless block_given?
    test_node.add_after(&block)
  end

  class Tree

    def log_test_building?
      Liza::Test.log_test_building?
    end

    attr_reader :tests, :parent, :children, :before_stack, :after_stack

    def initialize parent, before_stack, after_stack
      @tests = []
      initialize_parenting parent
      initialize_filters before_stack, after_stack
    end

    def initialize_parenting parent
      @parent = parent || self
      @children = []
      @parent.children << self if @parent != self
    end

    def initialize_filters before_stack, after_stack
      @before_top, @after_top = [], []
      @before_stack = before_stack.push @before_top
      @after_stack  = after_stack.unshift @after_top
    end

    def add_before &block
      puts "#{self.class} add_before to ##{object_id} #{block}" if log_test_building?
      @before_top.push block
    end

    def add_test words, &block
      puts "#{self.class} add_test to ##{object_id} #{words} #{block}" if log_test_building?
      tests << [words, block]
    end

    def add_after &block
      puts "#{self.class} add_after to ##{object_id} #{block}" if log_test_building?
      @after_top.push block
    end

    def branch_out words, &block
      self.class.new self, before_stack.dup, after_stack.dup
    end

  end

  section :default

  def self.subsystem
    subject_class.subsystem
  end

  # color

  def self.color
    subject_class.color
  rescue
    # a workaround for when subject_class is not a Unit
    :white
  end
end
