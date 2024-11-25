class DevSystem::CommandShortcutPart < Liza::Part

  insertion :controller do
    def self.shortcuts() = @shortcuts ||= {}

    def self.shortcut(a, b = nil)
      if b
        shortcuts[a.to_s] = b.to_s
      else
        shortcuts[a.to_s] || a.to_s
      end
    end
  end

  insertion :panel do
    def shortcuts() = @shortcuts ||= {}

    def shortcut(a, b = nil)
      if b
        shortcuts[a.to_s] = b.to_s
      else
        shortcuts[a.to_s] || a.to_s
      end
    end

    # called by the panel {#call} method after {#forge}
    def forge_shortcut(env)
      c = env[:controller] 
      env[:"#{c}_name"] = shortcut env[:"#{c}_name_original"] || ""
      log :high, "#{ "#{c}_name is".ljust_blanks 53 }#{env[:"#{c}_name"]}"
    end

    # called by the panel {#call} method after {#forge_shortcut}
    def find(env)
      c = env[:controller] 
      raise Liza::ConstNotFound if env[:"#{c}_name"].to_s.empty?
      env[:"#{c}_class"] = Liza.const "#{env[:"#{c}_name"]}_#{c}"
    rescue Liza::ConstNotFound
      env[:"#{c}_class"] = Liza.const "not_found_#{c}"
    ensure
      log :high, "#{ "#{c}_class is".ljust_blanks 53 }#{env[:"#{c}_class"]}"
    end
  
    # called by the panel {#call} method after {#find}
    def find_shortcut(env)
      c = env[:controller] 
      env[:"#{c}_action"] ||= env[:"#{c}_class"].shortcut env[:"#{c}_action_original"] || "default"
      log :high, "#{ "#{c}_name:#{c}_action is".ljust_blanks 53 }#{env[:"#{c}_name"]}:#{env[:"#{c}_action"]}"
    end

    # called by the panel {#call} method after {#find_shortcut}
    def forward(env)
      log :high, "forwarding"
      env[:"#{env[:controller]}_class"].call env
    end
  end

end
