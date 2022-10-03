module Liza
  class PartExtension
    def self.solder
      @solder ||= Liza.const first_namespace
    end

    def initialize solder
      @solder = solder
    end

    attr_reader :solder
  end
end
