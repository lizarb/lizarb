class MicroSystem::ShipCommandTest < DevSystem::SimpleCommandTest

  section :subject

  test :subject_class, :subject do
    assert_equality subject_class, MicroSystem::ShipCommand
    assert_equality subject.class, MicroSystem::ShipCommand
  end

end
