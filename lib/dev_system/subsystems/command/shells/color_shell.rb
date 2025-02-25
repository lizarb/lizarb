class DevSystem::ColorShell < DevSystem::Shell

  #

  def self.parse color
    return colors[color] if colors.has_key? color

    return rgb_from_int(color) if color.is_a? Integer
    return rgb_from_str(color) if color.is_a? String
    
    color
  end
  
  # Colors

  def self.colors
    PalletShell.colors
  end

  # 

  def self.rgb_from_int hex
    raise "Invalid type: #{hex.class}" unless hex.is_a? Integer
    raise "Invalid hex color: #{hex}" unless 0 <= hex && hex <= 0xffffff
    
    r = (hex >> 16) & 0xff
    g = (hex >> 8) & 0xff
    b = hex & 0xff
    [r, g, b]
  end

  def self.rgb_from_str hex
    raise "Invalid type: #{hex.class}" unless hex.is_a? String
    raise "Invalid hex color: #{hex}" unless hex =~ /^#?[0-9a-fA-F]{6}$/

    hex = hex[1..-1] if hex[0] == "#"
    rgb_from_int hex.to_i(16)
  end

  def self.rgb_to_str rgb
    raise "Invalid type: #{rgb.class}" unless rgb.is_a? Array
    raise "Invalid rgb color: #{rgb}" unless rgb.length == 3 && rgb.all? {|x| 0 <= x && x <= 0xff}

    r, g, b = rgb
    "##{"%02x" % r}#{"%02x" % g}#{"%02x" % b}"
  end

  def initialize(color)
    @rgb = self.class.parse color
  end

  def to_s
    @string ||= self.class.rgb_to_str @rgb
  end

  def to_rgb
    @rgb
  end

end
