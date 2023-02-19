module Liza
  class TestLogPart < Part

    insertion do

      LOG_BUILDING = false
      LOG_ASSERTION = true
      LOG_ASSERTION_MESSAGE = true
      LOG_CALL_BLOCK = true

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
        prefix = "error".yellow

        kaller = e.backtrace

        source_location = _caller_line_split(kaller[0])[0]
        source_location = source_location.gsub("#{Lizarb::CUR_DIR}/", "")

        log "                #{prefix} #{e.class.to_s.ljust 20} #{source_location}"

        puts "Exception!".red
        puts e.class.to_s.red
        puts e.message.red
        puts
        puts e.backtrace.join("\n").red
      end

      def self.log_test_building node, test_block
        log "                         the building blocks are".magenta

        node.before_stack.each do |stack|
          stack.each do |bl|
            log "                               before block #{_log_test_block bl}".magenta
          end
        end
        
        log "                                 test block #{_log_test_block test_block}".magenta

        node.after_stack.each do |stack|
          stack.each do |bl|
            log "                                after block #{_log_test_block bl}".magenta
          end
        end
      end

      def log_test_call prefix, &block
        source_location = block.source_location.join(":").gsub("#{Lizarb::CUR_DIR}/", "")
        source_location = source_location[0..-1]
        log "          #{prefix}                                #{source_location}"
      end

      def log_test_assertion method_name, kaller
        _inc_assertions
        prefix = "#{assertions.to_s.rjust 2, "0"} #{_log_test_assertion_tag method_name}"

        source_location = _caller_line_split(kaller[0])[0]
        source_location = source_location.gsub("#{Lizarb::CUR_DIR}/", "")

        log "             #{prefix} #{source_location}" if log_test_assertion?
      end

      def _log_test_assertion_tag method_name
        "#{log_test_assertion_result} #{method_name.to_s.ljust(20).bold.white}"
      end

      def self._log_test_block test_block
        test_block.source_location.join(":").gsub("#{Lizarb::CUR_DIR}/", "")
      end

      def _log_test_block test_block
        self.class._log_test_block test_block
      end

      def log_test_assertion_result
        case @last_result
        when :todo
          "  todo".blue
        when :passed
          "passed".green
        when :failed
          "failed".red
        else
          raise "Unknown result: #{@last_result}"
        end
      end

      def log_test_assertion_message b, msg
        if b
          log "                passed #{msg}".green 
        else
          log "                failed #{msg}".red
        end
      end

      def _caller_line_split s
        x = s.split ":in `"
        x[1] = x[1][0..-2]
        x
      end

    end

  end
end
