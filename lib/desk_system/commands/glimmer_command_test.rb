class DeskSystem::GlimmerCommandTest < DevSystem::SimpleCommandTest
  
  # 

  test :subject_class, :subject do
    assert_equality DeskSystem::GlimmerCommand, subject_class
    assert_equality DeskSystem::GlimmerCommand, subject.class
  end
  
end
