class NetSystem::ClientGeneratorTest < DevSystem::SimpleGeneratorTest
  
  # 

  test :subject_class, :subject do
    assert_equality NetSystem::ClientGenerator, subject_class
    assert_equality NetSystem::ClientGenerator, subject.class
  end
  
end
