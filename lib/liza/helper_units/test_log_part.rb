class Liza::TestLogPart < Liza::Part

  insertion do

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
    end

  end

end
