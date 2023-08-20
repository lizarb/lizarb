# ENV["VERBOSE"] ||= "1"
ENV["LOG_SYSTEMS"] ||= ""
ENV["LOG_BOXES"] ||= ""
ENV["LOG_VERSIONS"] ||= "1"

class App

  set :log_level, :normal
  set :log_erb, false
  set :log_render, false

  # Modes help you organize your application's behavior and settings.

  mode :code
  mode :demo
  
  # Systems help you organize your application's dependencies and RAM memory usage.

  system :dev
  system :happy
  system :net
  system :web

end
