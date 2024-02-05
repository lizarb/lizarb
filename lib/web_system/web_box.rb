class WebSystem::WebBox < Liza::Box

  # Preconfigure your rack panel

  configure :rack do
    #
  end

  # Preconfigure your request panel

  configure :request do
    #
  end

end

__END__

# view default.rb.erb
class WebBox < WebSystem::WebBox

  # Configure your rack panel

  configure :rack do
    # server (pick one, check gemfile)
    # server :agoo
    # server :falcon
    # server :iodine
    server :puma
    # server :thin

    set :files, App.root.join("web_files")
    set :host, "localhost"
    set :port, 3000
  end

  # Configure your request panel

  configure :request do
    router :simple
  end

end
