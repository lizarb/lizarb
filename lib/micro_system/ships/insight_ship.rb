class MicroSystem::InsightShip < MicroSystem::DockerShip

  define_service :kroki do
    image "yuzutech/kroki"
    default_port 8000
  end

end
