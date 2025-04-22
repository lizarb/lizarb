class MyNiceSystem::MyNiceCommandTest < DevSystem::SimpleCommandTest

  section :subject

  test :subject_class, :subject do
    assert_equality subject_class, MyNiceSystem::MyNiceCommand
    assert_equality subject.class, MyNiceSystem::MyNiceCommand
  end

end
