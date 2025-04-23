class PrimeSystem::InsightShip < MicroSystem::DockerShip

  define_service :kroki do
    image "yuzutech/kroki"
    default_port 8000
    persisted "/bitnami/kroki"
  end

end
