class NetSystem
  class Database < Liza::Controller

    def self.inherited sub
      super

      return if sub.name.nil?
      return if sub.name.end_with? "Db"
      raise "please rename #{sub.name} to #{sub.name}Db"
    end

    attr_reader :adapter

    def initialize adapter: get(:adapter).new
      @adapter = adapter
    end

    def self.set_adapter adapter_id
      set :adapter, Liza.const("#{adapter_id}_adapter")
    end

    def self.current
      Thread.current[last_namespace] ||= begin
        log "Connecting to #{last_namespace}"
        new
      end
    end

    def self.call(...); current.call(...); end
    def call(...); @adapter.call(...); end

  end
end
