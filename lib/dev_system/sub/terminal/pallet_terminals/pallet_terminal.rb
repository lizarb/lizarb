class DevSystem::PalletTerminal < DevSystem::Terminal

  #

  division!

  #

  def self.call args
    log "args = #{args.inspect}"

    log "Demo (#{colors.count} colors)"

    colors.each do |k, v|
      color = color_for(v)
      rgb = ColorShell.rgb_from_str(color)

      source = (self.is_a? Class) ? self : self.class
      s = "#{source} #{k.inspect} = #{v.inspect}"

      # bold
      log "\e[1m\e[38;2;#{rgb[0]};#{rgb[1]};#{rgb[2]}m#{s}\e[0m"
      # bold and italic
      log "\e[1;3m\e[38;2;#{rgb[0]};#{rgb[1]};#{rgb[2]}m#{s}\e[0m"
      # italic
      log "\e[3m\e[38;2;#{rgb[0]};#{rgb[1]};#{rgb[2]}m#{s}\e[0m"
      # normal
      log "\e[38;2;#{rgb[0]};#{rgb[1]};#{rgb[2]}m#{s}\e[0m"
    end
  end

  def self.key_name
    last_namespace.gsub("PalletTerminal", "")
  end

  def self.color_for color
    return color if color[0] == "#"
    color_for colors[color]
  end

  def self.colors
    get(:colors) || {}
  end

end
