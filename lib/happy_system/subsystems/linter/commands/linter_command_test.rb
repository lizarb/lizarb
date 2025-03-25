class HappySystem::LinterCommandTest < DevSystem::SimpleCommandTest

  section :subject

  test :subject_class, :subject do
    assert_equality subject_class, HappySystem::LinterCommand
    assert_equality subject.class, HappySystem::LinterCommand
  end

end
