class DevSystem::ColorShell < DevSystem::Shell

  #

  def self.parse color
    return colors[color] if colors.has_key? color

    return rgb_from_int(color) if color.is_a? Integer
    return rgb_from_str(color) if color.is_a? String
    
    color
  end
  
  # Colors

  @@colors = {}

  def self.colors
    @@colors
  end

  def self.color k, v
    v = @@colors[v] if v.is_a? Symbol
    v = rgb_from_int v if v.is_a? Integer
    v = rgb_from_str v if v.is_a? String
    @@colors[k] = v
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

  # Standard ANSI Colors:

  # red
  color :darkest_red,  0x330000
  color :darker_red,   0x660000
  color :dark_red,     0x990000
  color :red,          0xcc0000
  color :light_red,    0xff0000
  color :lighter_red,  0xff3333
  color :lightest_red, 0xff6666

  # green
  color :darkest_green,  0x003300
  color :darker_green,   0x006600
  color :dark_green,     0x009900
  color :green,          0x00cc00
  color :light_green,    0x00ff00
  color :lighter_green,  0x33ff33
  color :lightest_green, 0x66ff66

  # blue
  color :darkest_blue,  0x000033
  color :darker_blue,   0x000066
  color :dark_blue,     0x000099
  color :blue,          0x0000cc
  color :light_blue,    0x0000ff
  color :lighter_blue,  0x3333ff
  color :lightest_blue, 0x6666ff

  # yellow
  color :darkest_yellow,  0x333300
  color :darker_yellow,   0x666600
  color :dark_yellow,     0x999900
  color :yellow,          0xcccc00
  color :light_yellow,    0xffff00
  color :lighter_yellow,  0xffff33
  color :lightest_yellow, 0xffff66

  # magenta
  color :darkest_magenta,  0x330033
  color :darker_magenta,   0x660066
  color :dark_magenta,     0x990099
  color :magenta,          0xcc00cc
  color :light_magenta,    0xff00ff
  color :lighter_magenta,  0xff33ff
  color :lightest_magenta, 0xff66ff

  # cyan
  color :darkest_cyan,  0x003333
  color :darker_cyan,   0x006666
  color :dark_cyan,     0x009999
  color :cyan,          0x00cccc
  color :light_cyan,    0x00ffff
  color :lighter_cyan,  0x33ffff
  color :lightest_cyan, 0x66ffff

  # Black to White Transition:

  # black
  color :darkest_black,  0x000000
  color :darker_black,   0x080808
  color :dark_black,     0x101010
  color :black,          0x181818
  color :light_black,    0x202020
  color :lighter_black,  0x282828
  color :lightest_black, 0x303030

  # onyx
  color :darkest_onyx,  0x383838
  color :darker_onyx,   0x404040
  color :dark_onyx,     0x484848
  color :onyx,          0x505050
  color :light_onyx,    0x585858
  color :lighter_onyx,  0x606060
  color :lightest_onyx, 0x686868

  # gray
  color :darkest_gray,  0x707070
  color :darker_gray,   0x787878
  color :dark_gray,     0x808080
  color :gray,          0x888888
  color :light_gray,    0x909090
  color :lighter_gray,  0x989898
  color :lightest_gray, 0xa0a0a0

  # silver
  color :darkest_silver,  0xa8a8a8
  color :darker_silver,   0xb0b0b0
  color :dark_silver,     0xb8b8b8
  color :silver,          0xc0c0c0
  color :light_silver,    0xc8c8c8
  color :lighter_silver,  0xd0d0d0
  color :lightest_silver, 0xd8d8d8

  # white
  color :darkest_white,  0xe0e0e0
  color :darker_white,   0xe8e8e8
  color :dark_white,     0xf0f0f0
  color :white,          0xf8f8f8
  color :light_white,    0xffffff
  color :lighter_white,  0xffffff
  color :lightest_white, 0xffffff

  # Red to Orange Transition:

  # ruby
  color :darkest_ruby,  0x330000
  color :darker_ruby,   0x660000
  color :dark_ruby,     0x990000
  color :ruby,          0xcc0000
  color :light_ruby,    0xff3333
  color :lighter_ruby,  0xff6666
  color :lightest_ruby, 0xff9999

  # ember
  color :darkest_ember,  0x4B0000
  color :darker_ember,   0x8F1B1B
  color :dark_ember,     0xD23535
  color :ember,          0xFF4A4A
  color :light_ember,    0xFF6E6E
  color :lighter_ember,  0xFF9292
  color :lightest_ember, 0xFFB6B6
  
  # vermilion
  color :darkest_vermilion,  0x661919
  color :darker_vermilion,   0x993333
  color :dark_vermilion,     0xcc4c4c
  color :vermilion,          0xff6666
  color :light_vermilion,    0xff9999
  color :lighter_vermilion,  0xffcccc
  color :lightest_vermilion, 0xffffe6

  # coral
  color :darkest_coral,  0x801b1b
  color :darker_coral,   0xff4040
  color :dark_coral,     0xff6b6b
  color :coral,          0xff9595
  color :light_coral,    0xffbfbf
  color :lighter_coral,  0xffdfdf
  color :lightest_coral, 0xffefef

  # Orange to Yellow Transition:

  # saffron
  color :darkest_saffron,  0x993300
  color :darker_saffron,   0xff6600
  color :dark_saffron,     0xff9900
  color :saffron,          0xffcc00
  color :light_saffron,    0xffe066
  color :lighter_saffron,  0xfff299
  color :lightest_saffron, 0xffffcc

  # orange
  color :darkest_orange,  0x331900
  color :darker_orange,   0x663300
  color :dark_orange,     0x994c00
  color :orange,          0xcc6600
  color :light_orange,    0xff8000
  color :lighter_orange,  0xff9933
  color :lightest_orange, 0xffb266

  # umber
  color :darkest_umber,  0x3d1f00
  color :darker_umber,   0x7a3f00
  color :dark_umber,     0xb85f00
  color :umber,          0xf57f00
  color :light_umber,    0xff9f40
  color :lighter_umber,  0xffbf80
  color :lightest_umber, 0xffdfbf

  # beige
  color :darkest_beige,  0x664c33
  color :darker_beige,   0x998066
  color :dark_beige,     0xccb499
  color :beige,          0xffe8cc
  color :light_beige,    0xfff4e6
  color :lighter_beige,  0xfff9f2
  color :lightest_beige, 0xfffcf8

  # Yellow to Green Transition:

  # topaz
  color :darkest_topaz,  0x665c33
  color :darker_topaz,   0x997f33
  color :dark_topaz,     0xcca233
  color :topaz,          0xffc533
  color :light_topaz,    0xffd966
  color :lighter_topaz,  0xffec99
  color :lightest_topaz, 0xffffcc

  # olive
  color :darkest_olive,  0x333300
  color :darker_olive,   0x666600
  color :dark_olive,     0x999900
  color :olive,          0xcccc00
  color :light_olive,    0xe6e600
  color :lighter_olive,  0xf2f233
  color :lightest_olive, 0xffff66

  # chartreuse
  color :darkest_chartreuse,  0x336600
  color :darker_chartreuse,   0x66cc00
  color :dark_chartreuse,     0x99ff00
  color :chartreuse,          0xccff33
  color :light_chartreuse,    0xe6ff66
  color :lighter_chartreuse,  0xf2ff99
  color :lightest_chartreuse, 0xffffcc

  # jade
  color :darkest_jade,  0x003320
  color :darker_jade,   0x006640
  color :dark_jade,     0x009960
  color :jade,          0x00cc80
  color :light_jade,    0x33ffa0
  color :lighter_jade,  0x66ffc0
  color :lightest_jade, 0x99ffe0

  # Green to Blue Transition:

  # turquoise
  color :darkest_turquoise,  0x004545
  color :darker_turquoise,   0x008080
  color :dark_turquoise,     0x00bfbf
  color :turquoise,          0x00efef
  color :light_turquoise,    0x33ffff
  color :lighter_turquoise,  0x66ffff
  color :lightest_turquoise, 0x99ffff

  # cerulean
  color :darkest_cerulean,  0x003366
  color :darker_cerulean,   0x006699
  color :dark_cerulean,     0x0099cc
  color :cerulean,          0x00ccff
  color :light_cerulean,    0x33e6ff
  color :lighter_cerulean,  0x66ffff
  color :lightest_cerulean, 0x99ffff

  # azure
  color :darkest_azure,  0x003366
  color :darker_azure,   0x0066cc
  color :dark_azure,     0x0099ff
  color :azure,          0x00ccff
  color :light_azure,    0x33daff
  color :lighter_azure,  0x66e6ff
  color :lightest_azure, 0x99f2ff

  # cobalt
  color :darkest_cobalt,  0x001933
  color :darker_cobalt,   0x003366
  color :dark_cobalt,     0x004c99
  color :cobalt,          0x0066cc
  color :light_cobalt,    0x3380ff
  color :lighter_cobalt,  0x6699ff
  color :lightest_cobalt, 0x99b3ff

  # Blue to Purple Transition:

  # periwinkle
  color :darkest_periwinkle,  0x666699
  color :darker_periwinkle,   0x9999cc
  color :dark_periwinkle,     0xccccff
  color :periwinkle,          0xe6e6ff
  color :light_periwinkle,    0xf2f2ff
  color :lighter_periwinkle,  0xf8f8ff
  color :lightest_periwinkle, 0xfcfcff

  # amethyst
  color :darkest_amethyst,  0x330066
  color :darker_amethyst,   0x660099
  color :dark_amethyst,     0x9933cc
  color :amethyst,          0xcc66ff
  color :light_amethyst,    0xe699ff
  color :lighter_amethyst,  0xf2ccff
  color :lightest_amethyst, 0xfae6ff

  # indigo
  color :darkest_indigo,  0x1c0033
  color :darker_indigo,   0x3d0066
  color :dark_indigo,     0x5f0099
  color :indigo,          0x8000cc
  color :light_indigo,    0xa133ff
  color :lighter_indigo,  0xc266ff
  color :lightest_indigo, 0xe399ff

  # lavender
  color :darkest_lavender,  0x4c3366
  color :darker_lavender,   0x9966cc
  color :dark_lavender,     0xcc99ff
  color :lavender,          0xe6ccff
  color :light_lavender,    0xf2e6ff
  color :lighter_lavender,  0xf8f2ff
  color :lightest_lavender, 0xfcfaff

  # Purple to Red Transition:

  # mauve
  color :darkest_mauve,  0x663366
  color :darker_mauve,   0x996699
  color :dark_mauve,     0xcc99cc
  color :mauve,          0xffccff
  color :light_mauve,    0xffe6ff
  color :lighter_mauve,  0xfff2ff
  color :lightest_mauve, 0xfff8ff

  # mulberry
  color :darkest_mulberry,  0x660033
  color :darker_mulberry,   0x990066
  color :dark_mulberry,     0xcc0099
  color :mulberry,          0xff00cc
  color :light_mulberry,    0xff33e6
  color :lighter_mulberry,  0xff66f2
  color :lightest_mulberry, 0xff99fa

  # fuchsia
  color :darkest_fuchsia,  0x660066
  color :darker_fuchsia,   0x990099
  color :dark_fuchsia,     0xcc00cc
  color :fuchsia,          0xff00ff
  color :light_fuchsia,    0xff33ff
  color :lighter_fuchsia,  0xff66ff
  color :lightest_fuchsia, 0xff99ff

  # pink
  color :darkest_pink,  0x330019
  color :darker_pink,   0x660033
  color :dark_pink,     0x99004c
  color :pink,          0xcc0066
  color :light_pink,    0xff007f
  color :lighter_pink,  0xff3399
  color :lightest_pink, 0xff66b2


end
