class MicroSystem::DockerShipTest < MicroSystem::ShipTest

  section :subject

  test :subject_class, :subject do
    assert_equality subject_class, MicroSystem::DockerShip
    assert_equality subject.class, MicroSystem::DockerShip
  end

  test :defined_services, :used_services do
    assert_equality subject_class.defined_services.keys, [:empty]
    assert_equality subject_class.used_services.keys, []
  end

  test_sections(
    :helpers=>{
      :constants=>[],
      :class_methods=>[:up, :start, :stop, :restart, :terminal, :docker_directory],
      :instance_methods=>[]
    },
    :default=>{
      :constants=>[],
      :class_methods=>[:compose, :dock, :get_content, :call, :get_comments],
      :instance_methods=>[:call]
    },
    :networks=>{
      :constants=>[],
      :class_methods=>[:shared_network, :create_network],
      :instance_methods=>[]
    },
    :services=>{
      :constants=>[:Service],
      :class_methods=>[:defined_services, :used_services, :define_service_class, :define_service, :use_service],
      :instance_methods=>[]
    },
    :terminal=>{
      :constants=>[:Terminal],
      :class_methods=>[],
      :instance_methods=>[:terminal, :is_service_running]
    },
    :dockerfiles=>{
      :constants=>[:Dockerfile],
      :class_methods=>[:defined_dockerfiles, :used_dockerfiles, :dockerfile, :define_dockerfile, :use_dockerfile],
      :instance_methods=>[]
    },
    :instance_hooks=>{
      :constants=>[],
      :class_methods=>[],
      :instance_methods=>[:before, :after]
    },
    :instance_helpers=>{
      :constants=>[],
      :class_methods=>[],
      :instance_methods=>[:volume_for]
    },
  )

end
