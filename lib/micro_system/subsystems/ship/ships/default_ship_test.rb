class MicroSystem::DefaultShipTest < MicroSystem::DockerShipTest

  section :subject

  test :subject_class, :subject do
    assert_equality subject_class, MicroSystem::DefaultShip
    assert_equality subject.class, MicroSystem::DefaultShip
  end

  test :defined_services, :used_services do
    assert_equality subject_class.defined_services.keys, [:hello_world]
    assert_equality subject_class.used_services.keys, [:hello_world]
  end

end
