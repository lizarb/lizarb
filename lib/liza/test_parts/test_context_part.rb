module Liza
  class TestContextPart < Part

    insertion do
      def self.context
        @context ||= Liza::TestContextPart::Extension.new self
      end

      def self.before &block
        block_given? || raise(ArgumentError, "No block given")

        context.add_before block
      end

      def self.after &block
        block_given? || raise(ArgumentError, "No block given")

        context.add_after block
      end

      def self.group *_words, &block
        block_given? || raise(ArgumentError, "No block given")

        context.open_group
        instance_exec &block
        context.close_group
      end
    end

    extension do
      # group

      def open_group
        befores.push befores.last.dup
        afters.push afters.last.dup
      end

      def close_group
        befores.pop
        afters.pop
      end

      # before

      def befores
        @befores ||= _befores_from_superclass + [[]]
      end

      def add_before block
        befores.last.push block
      end

      def _befores_from_superclass
        if solder.superclass.respond_to? :context
          solder.superclass.context.befores.dup
        else
          []
        end
      end

      # after

      def afters
        @afters ||= _afters_from_superclass + [[]]
      end

      def add_after block
        afters.last.push block
      end

      def _afters_from_superclass
        if solder.superclass.respond_to? :context
          solder.superclass.context.afters.dup
        else
          []
        end
      end
    end

  end
end
