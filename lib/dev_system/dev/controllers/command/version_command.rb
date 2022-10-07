class DevSystem
  class VersionCommand < Command

    def self.call args
      puts Lizarb::VERSION
    end

  end
end
