class WorkBox < WorkSystem::WorkBox

  configure :event do
    # Event.panel gives you read-access to this instance
  end

  configure :publisher do
    # Publisher.panel gives you read-access to this instance
  end

  configure :subscriber do
    # Subscriber.panel gives you read-access to this instance
  end

end