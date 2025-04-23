class MicroSystem::DefaultShip < MicroSystem::DockerShip

  define_service :hello_world do
    image 'hello-world:latest'
    default_port 80
  end

  use_service :hello_world

end
