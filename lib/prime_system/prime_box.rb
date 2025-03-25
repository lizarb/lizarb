class PrimeSystem::PrimeBox < Liza::Box

  section :preconfiguration

  preconfigure :epic do
    # EpicPanel.instance gives you read-access to this instance
  end

  preconfigure :insight do
    # InsightPanel.instance gives you read-access to this instance
  end

end