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
    def forge_shortcut(menv)
      c = menv[:controller]
      menv[:"#{c}_name"] = shortcut menv[:"#{c}_name_original"] || ""
      log :high, "#{ "#{c}_name is".ljust_blanks 53 }#{menv[:"#{c}_name"]}"
    end

    # called by the panel {#call} method after {#forge_shortcut}
    def find(menv)
      c = menv[:controller]
      raise Liza::ConstNotFound if menv[:"#{c}_name"].to_s.empty?
      menv[:"#{c}_class"] = Liza.const "#{menv[:"#{c}_name"]}_#{c}"
    rescue Liza::ConstNotFound
      menv[:"#{c}_class"] = Liza.const "not_found_#{c}"
    ensure
      log :high, "#{ "#{c}_class is".ljust_blanks 53 }#{menv[:"#{c}_class"]}"
    end
  
    # called by the panel {#call} method after {#find}
    def find_shortcut(menv)
      c = menv[:controller]
      menv[:"#{c}_action"] ||= menv[:"#{c}_class"].shortcut menv[:"#{c}_action_original"] || "default"
      log :high, "#{ "#{c}_name:#{c}_action is".ljust_blanks 53 }#{menv[:"#{c}_name"]}:#{menv[:"#{c}_action"]}"
    end

    # called by the panel {#call} method after {#find_shortcut}
    def forward(menv)
      log :high, "forwarding"
      menv[:"#{menv[:controller]}_class"].call menv
    end
  end

end
