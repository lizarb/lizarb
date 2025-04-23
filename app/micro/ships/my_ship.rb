class MyShip < MicroSystem::DockerShip

  use_service :kroki, ship: :insight do
    # port 8000
  end

end
