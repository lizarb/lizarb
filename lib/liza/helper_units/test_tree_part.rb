class Liza::TestTreePart < Liza::Part

  insertion do

    @before_stack = []
    @after_stack = []
    
    def self.before_stack; @before_stack ||= superclass.before_stack.dup end
    def self.after_stack;  @after_stack  ||= superclass.after_stack.dup end
    
    def self.test_node; @test_node ||= test_tree end
    def self.test_tree; @test_tree ||= Liza::TestTreePart.new nil, before_stack, after_stack end
    
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

  end

  #

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
