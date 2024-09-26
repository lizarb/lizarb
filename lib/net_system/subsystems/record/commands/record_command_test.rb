class NetSystem::RecordCommandTest < DevSystem::SimpleCommandTest
  
  # 

  test :subject_class, :subject do
    assert_equality NetSystem::RecordCommand, subject_class
    assert_equality NetSystem::RecordCommand, subject.class
  end
  
end
