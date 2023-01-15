class DevSystem
  class GeneratorDslMainPart < Liza::Part

    insertion do

      def self.call args
        log :higher, "Called #{self}.#{__method__} with args #{args}"

        name = args.shift || raise("args[0] should contain NAME")
        name = name.downcase

        memo.each do |label, bl|
          log "Generating #{label}"
          g = new label, name, args
          g.instance_exec &bl
          g.call
        end

        puts
        log "done"
      end

      def self.memo()= @memo ||= {}

      def self.generate(label, &block)= memo[label] = block

      attr_reader :label, :name, :args

      def initialize label, name, args
        @label, @name, @args = label, name, args
      end

      def call
        FileShell.write folder, filename, "#{content}\n"
      end

      %w|folder filename content|.each do |s|
        class_eval <<-CODE, __FILE__, __LINE__ + 1
          attr_reader :#{s}

          def #{s} #{s} = nil
            if #{s}
              @#{s} = #{s}
            else
              @#{s}
            end
          end
        CODE
      end

    end

  end
end
