App.call ARGV do

  # Systems help you organize your application's dependencies and RAM memory usage.
  # Learn more: http://guides.lizarb.org/systems.html

  system :dev
  system :happy
  system :net
  system :web

  # Modes help you organize your application's behavior and settings.
  # Learn more: http://guides.lizarb.org/modes.html

  mode :code
  mode :demo

end
