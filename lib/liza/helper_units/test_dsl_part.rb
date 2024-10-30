class Liza::TestDslPart < Liza::Part
  insertion do

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

  end
end
