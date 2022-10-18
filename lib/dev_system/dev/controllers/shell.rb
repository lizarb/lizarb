class DevSystem
  class Shell < Liza::Controller
    def windows?
      RUBY_PLATFORM =~ /win32/
    end

    def unix?
      linux? || mac?
    end

    def linux?
      RUBY_PLATFORM =~ /linux/
    end

    def mac?
      RUBY_PLATFORM =~ /darwin/
    end
  end
end
