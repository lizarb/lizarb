module Liza
  class TestSubjectPart < Part

    insertion do
      def self.subject_class
        @subject_class ||= Liza::const name[0..-5]
      end

      def subject_class
        self.class.subject_class
      end

      def subject
        @subject ||= subject_class.new
      end
    end

  end
end
