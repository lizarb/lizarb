class NetSystem::FilebaseGeneratorTest < DevSystem::ControllerGeneratorTest

  section :subject

  test :subject_class, :subject do
    assert_equality subject_class, NetSystem::FilebaseGenerator
    assert_equality subject.class, NetSystem::FilebaseGenerator
  end

end
