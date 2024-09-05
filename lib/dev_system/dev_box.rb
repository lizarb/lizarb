class DevSystem::DevBox < Liza::Box

  # Preconfigure your bench panel
  
  configure :bench do
    # 
    rescue_from :not_found
  end

  forward :bench

  # Preconfigure your command panel
  
  configure :command do
    # 
    rescue_from :not_found
  end

  forward :command
  forward :command, :input
  forward :command, :pick_one
  forward :command, :pick_many

  # Preconfigure your generator panel
  
  configure :generator do
    # 
    rescue_from :not_found
  end

  forward :generator, :generate => :call

  # Preconfigure your log panel

  configure :log do
    # 
    sidebar_size 40
  end

  forward :log, :logg => :call

  # Preconfigure your shell panel

  configure :shell do
    # 
  end

  forward :shell, :convert
  forward :shell, :format

end
