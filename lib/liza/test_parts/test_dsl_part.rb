module Liza
  class TestDslPart < Part
    insertion do
      def self.test *words, &block
        Liza.log "#{inspect}.test #{words}, &block"
        block_given? || raise(ArgumentError, "No block given")

        key = [
          block.source_location,
          'b',
          context.befores.flatten.map(&:source_location),
          'a',
          context.afters.flatten.map(&:source_location),
        ].flatten.join("-")

        key.gsub! Lizarb::CUR_DIR, ""

        instances[key] ||= new  words,
                                context.befores.flatten.uniq,
                                context.afters.flatten.uniq,
                                &block
      end

      def self.instances
        @instances ||= {}
      end

      def self.call class_index, class_count
        counter_class = "#{class_index.to_s.rjust 3, "0"}/#{class_count.to_s.rjust 3, "0"}"

        puts "- #{counter_class} #{self} (#{instances.size} tests)".cyan

        instances.values.each_with_index do |instance, i|
          counter_instance = "#{(i+=1).to_s.rjust 2, '0'}/#{instances.size.to_s.rjust 2, '0'}"
          label = instance.words_as_label

          puts "  #{ counter_class } #{ counter_instance } (#{ label })".light_cyan

          instance.call
        end
      end

      #

      attr_reader :words

      def initialize words, befores, afters, &block
        @words, @befores, @afters, @block = words, befores, afters, block
      end

      def call
        catch :critical do
          @befores.each do |bl|
            _call_log "B&", &bl
            instance_exec &bl
          end

          bl = @block
          _call_log " &", &bl
          instance_exec &bl

          @afters.each do |bl|
            _call_log "A&", &bl
            instance_exec &bl
          end
        end
      rescue Exception => e
        self.class._assertion_errored e
        _rescue_log e
      ensure
        puts
      end

      def words_as_label
        label = words.to_s
        label = label[1..-2] if label.start_with? "["
        label = label[1..-2] if label.start_with? "{"
        label
      end

      def _rescue_log e
        prefix = "error"

        kaller = e.backtrace

        source_location = _caller_line_split(kaller[0])[0]
        source_location = source_location.gsub("#{Lizarb::CUR_DIR}/", "")

        log "                      #{prefix}  #{source_location}"

        puts "Exception!".red
        puts e.class.to_s.red
        puts e.message.red
        puts
        puts e.backtrace.join("\n").red
      end

      def _call_log prefix, &block
        source_location = block.source_location.join(":").gsub("#{Lizarb::CUR_DIR}/", "")
        source_location = source_location[0..-1]
        log "          #{prefix}                 #{source_location}"
      end

      def _assertion_log method_name, kaller
        _inc_assertions
        method_name = method_name.to_s.ljust 6
        prefix = "#{assertions} #{method_name} #{@last_result}"

        source_location = _caller_line_split(kaller[0])[0]
        source_location = source_location.gsub("#{Lizarb::CUR_DIR}/", "")

        log "             #{prefix} #{source_location}"
      end

      def _caller_line_split s
        x = s.split ":in `"
        x[1] = x[1][0..-2]
        x
      end
    end
  end
end
