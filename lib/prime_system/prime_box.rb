class PrimeSystem::PrimeBox < Liza::Box

  section :preconfiguration

  preconfigure :agent do
    # Agent.panel gives you read-access to this instance
  end

  preconfigure :epic do
    # Epic.panel gives you read-access to this instance
  end

  preconfigure :insight do
    # Insight.panel gives you read-access to this instance
  end

end