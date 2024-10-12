# This is a LizaRB Application
# Learn more: https://lizarb.org/

class App

  # Choose your Gemfile

  gemfile "Gemfile"

  # Choose your Application Directory

  directory "app"

  # Choose your Log Transparency
  #
  #    1       2     3     4      5      6        7
  # :lowest :lower :low :normal :high :higher :highest
  #
  # log_boot  4
  # log_level 4

  # Choose your Mode and sources of Environment Variables

  # mode :code # default
  # mode :demo

  # env_vars ".env", ":directory.env", ":directory.:mode.env", mandatory: false

  # Systems help you organize your application's dependencies and RAM memory usage.

  system :dev # default

end
