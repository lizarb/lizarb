class DevSystem::SolarizedPalletTerminal < DevSystem::PalletTerminal

  # https://ethanschoonover.com/solarized/
  #
  # $base03:    #002b36;
  # $base02:    #073642;
  # $base01:    #586e75;
  # $base00:    #657b83;
  # $base0:     #839496;
  # $base1:     #93a1a1;
  # $base2:     #eee8d5;
  # $base3:     #fdf6e3;
  # $yellow:    #b58900;
  # $orange:    #cb4b16;
  # $red:       #dc322f;
  # $magenta:   #d33682;
  # $violet:    #6c71c4;
  # $blue:      #268bd2;
  # $cyan:      #2aa198;
  # $green:     #859900;

  set :colors, {}
  add :colors, :red,       :solarized_red
  add :colors, :orange,    :solarized_orange
  add :colors, :yellow,    :solarized_yellow
  add :colors, :green,     :solarized_green
  add :colors, :cyan,      :solarized_cyan
  add :colors, :blue,      :solarized_blue
  add :colors, :violet,    :solarized_violet
  add :colors, :magenta,   :solarized_magenta

  add :colors, :solarized_base03,    "#002B36"
  add :colors, :solarized_base02,    "#073642"
  add :colors, :solarized_base01,    "#586E75"
  add :colors, :solarized_base00,    "#657B83"
  add :colors, :solarized_base0,     "#839496"
  add :colors, :solarized_base1,     "#93A1A1"
  add :colors, :solarized_base2,     "#EEE8D5"
  add :colors, :solarized_base3,     "#FDF6E3"
  add :colors, :solarized_red,       "#DC322F"
  add :colors, :solarized_orange,    "#CB4B16"
  add :colors, :solarized_yellow,    "#B58900"
  add :colors, :solarized_green,     "#859900"
  add :colors, :solarized_cyan,      "#2AA198"
  add :colors, :solarized_blue,      "#268BD2"
  add :colors, :solarized_violet,    "#6C71C4"
  add :colors, :solarized_magenta,   "#D33682"

end
