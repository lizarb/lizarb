class MicroSystem::DockerShipTest < MicroSystem::ShipTest

  section :subject

  test :subject_class, :subject do
    assert_equality subject_class, MicroSystem::DockerShip
    assert_equality subject.class, MicroSystem::DockerShip
  end

  test :defined_services, :used_services do
    assert_equality subject_class.defined_services.keys, []
    assert_equality subject_class.used_services.keys, []
  end

end
