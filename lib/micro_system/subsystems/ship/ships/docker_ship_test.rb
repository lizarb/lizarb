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
      :class_methods=>[:up, :start, :stop, :restart],
      :instance_methods=>[]
    },
    :default=>{
      :constants=>[],
      :class_methods=>[:compose, :dock, :get_content, :call, :get_comments],
      :instance_methods=>[]
    },
    :services=>{
      :constants=>[:Service],
      :class_methods=>[:defined_services, :used_services, :define_service, :use_service],
      :instance_methods=>[]
    },
  )

end
