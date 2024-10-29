class DevSystem::DevBox < Liza::Box

  preconfigure :bench do
    # BenchPanel.instance gives you read-access to this instance
    rescue_from :not_found
  end

  forward :bench

  preconfigure :command do
    # CommandPanel.instance gives you read-access to this instance
    rescue_from :not_found
  end

  forward :command
  forward :command, :input
  forward :command, :pick_one
  forward :command, :pick_many

  preconfigure :generator do
    # GeneratorPanel.instance gives you read-access to this instance
    rescue_from :not_found
  end

  forward :generator, :generate => :call

  preconfigure :log do
    # LogPanel.instance gives you read-access to this instance
    sidebar_size 40
  end

  forward :log, :logg => :call

  preconfigure :shell do
    # ShellPanel.instance gives you read-access to this instance
  end

  forward :shell, :convert
  forward :shell, :format

end
