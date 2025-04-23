class MyShipTest < MicroSystem::DockerShipTest

  section :subject

  test :subject_class, :subject do
    assert_equality subject_class, MyShip
    assert_equality subject.class, MyShip
  end

  test :defined_services, :used_services do
    assert_equality subject_class.defined_services.keys, []
    assert_equality subject_class.used_services.keys, [:kroki]
  end

end
