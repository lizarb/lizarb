class DevSystem::PalletShell < DevSystem::Shell

  @@colors = {}

  def self.colors
    @@colors
  end

  def self.add k, v
    v = @@colors[v] if v.is_a? Symbol
    v = ColorShell.rgb_from_int v if v.is_a? Integer
    v = ColorShell.rgb_from_str v if v.is_a? String
    @@colors[k] = v
  end

  # Standard ANSI Colors:

  # red
  add :darkest_red,  0x330000
  add :darker_red,   0x660000
  add :dark_red,     0x990000
  add :red,          0xcc0000
  add :light_red,    0xff0000
  add :lighter_red,  0xff3333
  add :lightest_red, 0xff6666

  # green
  add :darkest_green,  0x003300
  add :darker_green,   0x006600
  add :dark_green,     0x009900
  add :green,          0x00cc00
  add :light_green,    0x00ff00
  add :lighter_green,  0x33ff33
  add :lightest_green, 0x66ff66

  # blue
  add :darkest_blue,  0x000033
  add :darker_blue,   0x000066
  add :dark_blue,     0x000099
  add :blue,          0x0000cc
  add :light_blue,    0x0000ff
  add :lighter_blue,  0x3333ff
  add :lightest_blue, 0x6666ff

  # yellow
  add :darkest_yellow,  0x333300
  add :darker_yellow,   0x666600
  add :dark_yellow,     0x999900
  add :yellow,          0xcccc00
  add :light_yellow,    0xffff00
  add :lighter_yellow,  0xffff33
  add :lightest_yellow, 0xffff66

  # magenta
  add :darkest_magenta,  0x330033
  add :darker_magenta,   0x660066
  add :dark_magenta,     0x990099
  add :magenta,          0xcc00cc
  add :light_magenta,    0xff00ff
  add :lighter_magenta,  0xff33ff
  add :lightest_magenta, 0xff66ff

  # cyan
  add :darkest_cyan,  0x003333
  add :darker_cyan,   0x006666
  add :dark_cyan,     0x009999
  add :cyan,          0x00cccc
  add :light_cyan,    0x00ffff
  add :lighter_cyan,  0x33ffff
  add :lightest_cyan, 0x66ffff

  # Black to White Transition:

  # black
  add :darkest_black,  0x000000
  add :darker_black,   0x080808
  add :dark_black,     0x101010
  add :black,          0x181818
  add :light_black,    0x202020
  add :lighter_black,  0x282828
  add :lightest_black, 0x303030

  # onyx
  add :darkest_onyx,  0x383838
  add :darker_onyx,   0x404040
  add :dark_onyx,     0x484848
  add :onyx,          0x505050
  add :light_onyx,    0x585858
  add :lighter_onyx,  0x606060
  add :lightest_onyx, 0x686868

  # gray
  add :darkest_gray,  0x707070
  add :darker_gray,   0x787878
  add :dark_gray,     0x808080
  add :gray,          0x888888
  add :light_gray,    0x909090
  add :lighter_gray,  0x989898
  add :lightest_gray, 0xa0a0a0

  # silver
  add :darkest_silver,  0xa8a8a8
  add :darker_silver,   0xb0b0b0
  add :dark_silver,     0xb8b8b8
  add :silver,          0xc0c0c0
  add :light_silver,    0xc8c8c8
  add :lighter_silver,  0xd0d0d0
  add :lightest_silver, 0xd8d8d8

  # white
  add :darkest_white,  0xe0e0e0
  add :darker_white,   0xe8e8e8
  add :dark_white,     0xf0f0f0
  add :white,          0xf8f8f8
  add :light_white,    0xffffff
  add :lighter_white,  0xffffff
  add :lightest_white, 0xffffff

  # Red to Orange Transition:

  # ruby
  add :darkest_ruby,  0x330000
  add :darker_ruby,   0x660000
  add :dark_ruby,     0x990000
  add :ruby,          0xcc0000
  add :light_ruby,    0xff3333
  add :lighter_ruby,  0xff6666
  add :lightest_ruby, 0xff9999

  # ember
  add :darkest_ember,  0x4B0000
  add :darker_ember,   0x8F1B1B
  add :dark_ember,     0xD23535
  add :ember,          0xFF4A4A
  add :light_ember,    0xFF6E6E
  add :lighter_ember,  0xFF9292
  add :lightest_ember, 0xFFB6B6
  
  # vermilion
  add :darkest_vermilion,  0x661919
  add :darker_vermilion,   0x993333
  add :dark_vermilion,     0xcc4c4c
  add :vermilion,          0xff6666
  add :light_vermilion,    0xff9999
  add :lighter_vermilion,  0xffcccc
  add :lightest_vermilion, 0xffffe6

  # coral
  add :darkest_coral,  0x801b1b
  add :darker_coral,   0xff4040
  add :dark_coral,     0xff6b6b
  add :coral,          0xff9595
  add :light_coral,    0xffbfbf
  add :lighter_coral,  0xffdfdf
  add :lightest_coral, 0xffefef

  # Orange to Yellow Transition:

  # saffron
  add :darkest_saffron,  0x993300
  add :darker_saffron,   0xff6600
  add :dark_saffron,     0xff9900
  add :saffron,          0xffcc00
  add :light_saffron,    0xffe066
  add :lighter_saffron,  0xfff299
  add :lightest_saffron, 0xffffcc

  # orange
  add :darkest_orange,  0x331900
  add :darker_orange,   0x663300
  add :dark_orange,     0x994c00
  add :orange,          0xcc6600
  add :light_orange,    0xff8000
  add :lighter_orange,  0xff9933
  add :lightest_orange, 0xffb266

  # umber
  add :darkest_umber,  0x3d1f00
  add :darker_umber,   0x7a3f00
  add :dark_umber,     0xb85f00
  add :umber,          0xf57f00
  add :light_umber,    0xff9f40
  add :lighter_umber,  0xffbf80
  add :lightest_umber, 0xffdfbf

  # beige
  add :darkest_beige,  0x664c33
  add :darker_beige,   0x998066
  add :dark_beige,     0xccb499
  add :beige,          0xffe8cc
  add :light_beige,    0xfff4e6
  add :lighter_beige,  0xfff9f2
  add :lightest_beige, 0xfffcf8

  # Yellow to Green Transition:

  # topaz
  add :darkest_topaz,  0x665c33
  add :darker_topaz,   0x997f33
  add :dark_topaz,     0xcca233
  add :topaz,          0xffc533
  add :light_topaz,    0xffd966
  add :lighter_topaz,  0xffec99
  add :lightest_topaz, 0xffffcc

  # olive
  add :darkest_olive,  0x333300
  add :darker_olive,   0x666600
  add :dark_olive,     0x999900
  add :olive,          0xcccc00
  add :light_olive,    0xe6e600
  add :lighter_olive,  0xf2f233
  add :lightest_olive, 0xffff66

  # chartreuse
  add :darkest_chartreuse,  0x336600
  add :darker_chartreuse,   0x66cc00
  add :dark_chartreuse,     0x99ff00
  add :chartreuse,          0xccff33
  add :light_chartreuse,    0xe6ff66
  add :lighter_chartreuse,  0xf2ff99
  add :lightest_chartreuse, 0xffffcc

  # jade
  add :darkest_jade,  0x003320
  add :darker_jade,   0x006640
  add :dark_jade,     0x009960
  add :jade,          0x00cc80
  add :light_jade,    0x33ffa0
  add :lighter_jade,  0x66ffc0
  add :lightest_jade, 0x99ffe0

  # Green to Blue Transition:

  # turquoise
  add :darkest_turquoise,  0x004545
  add :darker_turquoise,   0x008080
  add :dark_turquoise,     0x00bfbf
  add :turquoise,          0x00efef
  add :light_turquoise,    0x33ffff
  add :lighter_turquoise,  0x66ffff
  add :lightest_turquoise, 0x99ffff

  # cerulean
  add :darkest_cerulean,  0x003366
  add :darker_cerulean,   0x006699
  add :dark_cerulean,     0x0099cc
  add :cerulean,          0x00ccff
  add :light_cerulean,    0x33e6ff
  add :lighter_cerulean,  0x66ffff
  add :lightest_cerulean, 0x99ffff

  # azure
  add :darkest_azure,  0x003366
  add :darker_azure,   0x0066cc
  add :dark_azure,     0x0099ff
  add :azure,          0x00ccff
  add :light_azure,    0x33daff
  add :lighter_azure,  0x66e6ff
  add :lightest_azure, 0x99f2ff

  # cobalt
  add :darkest_cobalt,  0x001933
  add :darker_cobalt,   0x003366
  add :dark_cobalt,     0x004c99
  add :cobalt,          0x0066cc
  add :light_cobalt,    0x3380ff
  add :lighter_cobalt,  0x6699ff
  add :lightest_cobalt, 0x99b3ff

  # Blue to Purple Transition:

  # periwinkle
  add :darkest_periwinkle,  0x666699
  add :darker_periwinkle,   0x9999cc
  add :dark_periwinkle,     0xccccff
  add :periwinkle,          0xe6e6ff
  add :light_periwinkle,    0xf2f2ff
  add :lighter_periwinkle,  0xf8f8ff
  add :lightest_periwinkle, 0xfcfcff

  # amethyst
  add :darkest_amethyst,  0x330066
  add :darker_amethyst,   0x660099
  add :dark_amethyst,     0x9933cc
  add :amethyst,          0xcc66ff
  add :light_amethyst,    0xe699ff
  add :lighter_amethyst,  0xf2ccff
  add :lightest_amethyst, 0xfae6ff

  # indigo
  add :darkest_indigo,  0x1c0033
  add :darker_indigo,   0x3d0066
  add :dark_indigo,     0x5f0099
  add :indigo,          0x8000cc
  add :light_indigo,    0xa133ff
  add :lighter_indigo,  0xc266ff
  add :lightest_indigo, 0xe399ff

  # lavender
  add :darkest_lavender,  0x4c3366
  add :darker_lavender,   0x9966cc
  add :dark_lavender,     0xcc99ff
  add :lavender,          0xe6ccff
  add :light_lavender,    0xf2e6ff
  add :lighter_lavender,  0xf8f2ff
  add :lightest_lavender, 0xfcfaff

  # Purple to Red Transition:

  # mauve
  add :darkest_mauve,  0x663366
  add :darker_mauve,   0x996699
  add :dark_mauve,     0xcc99cc
  add :mauve,          0xffccff
  add :light_mauve,    0xffe6ff
  add :lighter_mauve,  0xfff2ff
  add :lightest_mauve, 0xfff8ff

  # mulberry
  add :darkest_mulberry,  0x660033
  add :darker_mulberry,   0x990066
  add :dark_mulberry,     0xcc0099
  add :mulberry,          0xff00cc
  add :light_mulberry,    0xff33e6
  add :lighter_mulberry,  0xff66f2
  add :lightest_mulberry, 0xff99fa

  # fuchsia
  add :darkest_fuchsia,  0x660066
  add :darker_fuchsia,   0x990099
  add :dark_fuchsia,     0xcc00cc
  add :fuchsia,          0xff00ff
  add :light_fuchsia,    0xff33ff
  add :lighter_fuchsia,  0xff66ff
  add :lightest_fuchsia, 0xff99ff

  # pink
  add :darkest_pink,  0x330019
  add :darker_pink,   0x660033
  add :dark_pink,     0x99004c
  add :pink,          0xcc0066
  add :light_pink,    0xff007f
  add :lighter_pink,  0xff3399
  add :lightest_pink, 0xff66b2

end
