class DevSystem::NordPalletTerminal < DevSystem::PalletTerminal

  # https://www.nordtheme.com/docs/colors-and-palettes
  #
  # Polar Night
  # #2E3440 #3B4252 #434C5E #4C566A
  # Snow Storm
  # #D8DEE9 #E5E9F0 #ECEFF4
  # Frost
  # #8FBCBB #88C0D0 #81A1C1 #5E81AC
  # Aurora
  # #BF616A #D08770 #EBCB8B #A3BE8C #B48EAD
  #

  set :colors, {}
  add :colors, :red,     :nord_aurora_1
  add :colors, :orange,  :nord_aurora_2
  add :colors, :yellow,  :nord_aurora_3
  add :colors, :green,   :nord_aurora_4
  add :colors, :cyan,    :nord_frost_2
  add :colors, :blue,    :nord_frost_4
  add :colors, :violet,  :nord_storm_3
  add :colors, :magenta, :nord_aurora_5

  add :colors, :nord_night_1, "#2E3440"
  add :colors, :nord_night_2, "#3B4252"
  add :colors, :nord_night_3, "#434C5E"
  add :colors, :nord_night_4, "#4C566A"
  add :colors, :nord_storm_1, "#D8DEE9"
  add :colors, :nord_storm_2, "#E5E9F0"
  add :colors, :nord_storm_3, "#ECEFF4"
  add :colors, :nord_frost_1, "#8FBCBB"
  add :colors, :nord_frost_2, "#88C0D0"
  add :colors, :nord_frost_3, "#81A1C1"
  add :colors, :nord_frost_4, "#5E81AC"
  add :colors, :nord_aurora_1, "#BF616A"
  add :colors, :nord_aurora_2, "#D08770"
  add :colors, :nord_aurora_3, "#EBCB8B"
  add :colors, :nord_aurora_4, "#A3BE8C"
  add :colors, :nord_aurora_5, "#B48EAD"

end
