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
      env[:"#{c}_action"] = shortcut env[:"#{c}_action_original"] || "default"
      log "#{c}:action is #{env[:"#{c}_name"]}:#{env[:"#{c}_action"]}"
    end

    # called by the panel {#call} method after {#find}
    def find_shortcut(env)
      c = env[:controller]
      env[:"#{c}_action"] = env[:"#{c}_class"].shortcut env[:"#{c}_action_original"] || "default"
      log "#{c}:action is #{env[:"#{c}_name"]}:#{env[:"#{c}_action"]}"
    end
  end

end
