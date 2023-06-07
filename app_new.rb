# This is a LizaRB Application
# Learn more: http://lizarb.org/

# ENV["VERBOSE"] ||= "1"
ENV["LOG_SYSTEMS"] ||= ""
ENV["LOG_BOXES"] ||= ""
ENV["LOG_VERSIONS"] ||= "1"

class App

  # Modes help you organize your application's behavior and settings.

  mode :code
  mode :demo

  # Systems help you organize your application's dependencies and RAM memory usage.

  system :dev

end
