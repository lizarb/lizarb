class HappySystem::AxoCommandTest < DevSystem::SimpleCommandTest
  
  test :subject_class, :subject do
    assert_equality HappySystem::AxoCommand, subject_class
    assert_equality HappySystem::AxoCommand, subject.class
  end

end
