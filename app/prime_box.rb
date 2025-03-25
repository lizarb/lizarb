class PrimeBox < PrimeSystem::PrimeBox

  section :configuration

  configure :epic do
    # EpicPanel.instance gives you read-access to this instance
  end

  configure :insight do
    # InsightPanel.instance gives you read-access to this instance
  end

end