# ENV["VERBOSE"] ||= "1"

class App

  # Choose your level of log opacity

  # log_boot :highest
  # log_boot :higher
  # log_boot :high
  # log_boot :normal # default
  # log_boot :low
  # log_boot :lower
  # log_boot :lowest

  # App settings

  set :log_level, :normal
  set :log_erb, false
  set :log_render, false

  # Your mode is where you get global environment variables from

  # mode :code # default
  # mode :demo
  
  # Systems help you organize your application's dependencies and RAM memory usage.

  system :dev # default
  system :happy
  system :net
  system :web

end
