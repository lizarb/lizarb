class DevSystem::LocCommandTest < DevSystem::SimpleCommandTest
  
  # 

  test :subject_class, :subject do
    assert_equality DevSystem::LocCommand, subject_class
    assert_equality DevSystem::LocCommand, subject.class
  end
  
end
