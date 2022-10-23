class DevSystem
  class AppGenerator < Generator

    def self.call args
      log :higher, "Called #{self}.#{__method__} with args #{args}"
    end

  end
end
