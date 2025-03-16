# This is a LizaRB Application
# Learn more: https://lizarb.org/

class App

  # Choose your Name

  name "project_1"

  # Choose your Gemfile

  gemfile "Gemfile"

  # Choose your Application Directory

  directory "app"

  # Choose your Operation Mode

  mode :code
  # mode :demo

  # Choose your Log Transparency
  #
  #    1       2     3     4      5      6        7
  # :lowest :lower :low :normal :high :higher :highest
  #
  # log_boot  4
  # log_level 4

  # Choose your sources of Environment Variables

  # env_vars ".env", ":directory.env", ":directory.:mode.env", mandatory: false

  # Systems help you organize your application's dependencies and RAM memory usage.

  system :dev # default

end
