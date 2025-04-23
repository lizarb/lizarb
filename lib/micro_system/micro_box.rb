class MicroSystem::MicroBox < Liza::Box

  #
  
  preconfigure :ship do
    # Ship.panel gives you read-access to this instance
  end

  forward :ship, :dock => :call

end

__END__

# view default.rb.erb
class MicroBox < MicroSystem::MicroBox

  configure :ship do
    # Ship.panel gives you read-access to this instance

    # auto_dock :default
  end

end
