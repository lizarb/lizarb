class NetSystem::NetBox < Liza::Box

  preconfigure :client do
    # ClientPanel.instance gives you read-access to this instance
  end

  preconfigure :database do
    # DatabasePanel.instance gives you read-access to this instance
  end

  preconfigure :record do
    # RecordPanel.instance gives you read-access
  end
  
  preconfigure :filebase do
    # FilebasePanel.instance gives you read-access to this instance
  end

end

__END__

# view default.rb.erb
class NetBox < NetSystem::NetBox

  configure :client do
    # ClientPanel.instance gives you read-access to this instance
  end

  configure :database do
    # DatabasePanel.instance gives you read-access to this instance
  end

  configure :record do
    # RecordPanel.instance gives you read-access
  end

end