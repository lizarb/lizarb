# ENV["VERBOSE"] ||= "1"

class App

  # Choose your Gemfile

  gemfile "Gemfile"

  # Choose your Application Directory

  folder "app"

  # Choose your Systems Directory

  # sys_folder "app_liza_sys"
  
  # Choose your Log Transparency
  #
  #    1       2     3     4      5      6        7
  # :lowest :lower :low :normal :high :higher :highest
  #
  # log_boot  4
  # log_level 4

  # Your mode is where you get global environment variables from

  # mode :code # default
  # mode :demo
  
  # Systems help you organize your application's dependencies and RAM memory usage.

  system :dev # default
  system :happy if coding?
  system :net
  system :web
  system :work
  system :micro
  system :desk
  system :crypto
  system :media
  system :art
  system :deep
  system :lab

end
