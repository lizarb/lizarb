class PrimeBox < PrimeSystem::PrimeBox

  section :configuration

  configure :agent do
    # Agent.panel gives you read-access to this instance
  end

  configure :epic do
    # Epic.panel gives you read-access to this instance
  end

  configure :insight do
    # Insight.panel gives you read-access to this instance
  end

end