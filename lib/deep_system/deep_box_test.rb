class DeepSystem::DeepBoxTest < Liza::BoxTest
  
  test :subject_class, :subject do
    assert_equality DeepSystem::DeepBox, subject_class
    assert_equality DeepSystem::DeepBox, subject.class
  end

end
