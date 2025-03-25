class HappySystem::LinterGeneratorTest < DevSystem::ControllerGeneratorTest

  section :subject

  test :subject_class, :subject do
    assert_equality subject_class, HappySystem::LinterGenerator
    assert_equality subject.class, HappySystem::LinterGenerator
  end

end
