class NetSystem::ClientCommandTest < DevSystem::SimpleCommandTest
  
  # 

  test :subject_class, :subject do
    assert_equality NetSystem::ClientCommand, subject_class
    assert_equality NetSystem::ClientCommand, subject.class
  end
  
end
