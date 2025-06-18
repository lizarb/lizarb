class NetSystem::DatabaseGeneratorTest < DevSystem::ControllerGeneratorTest

  section :subject

  test :subject_class, :subject do
    assert_equality subject_class, NetSystem::DatabaseGenerator
    assert_equality subject.class, NetSystem::DatabaseGenerator
  end

end
