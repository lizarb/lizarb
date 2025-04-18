class MicroSystem::ShipGeneratorTest < DevSystem::ControllerGeneratorTest

  section :subject

  test :subject_class, :subject do
    assert_equality subject_class, MicroSystem::ShipGenerator
    assert_equality subject.class, MicroSystem::ShipGenerator
  end

end
