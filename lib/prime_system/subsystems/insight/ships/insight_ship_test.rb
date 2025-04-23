class PrimeSystem::InsightShipTest < MicroSystem::DockerShipTest

  section :subject

  test :subject_class, :subject do
    assert_equality subject_class, PrimeSystem::InsightShip
    assert_equality subject.class, PrimeSystem::InsightShip
  end

  test :defined_services, :used_services do
    assert_equality subject_class.defined_services.keys, [:kroki]
    assert_equality subject_class.used_services.keys, []
  end


end
