class WorkSystem::WorkBoxTest < Liza::BoxTest
  
  test :subject_class, :subject do
    assert_equality WorkSystem::WorkBox, subject_class
    assert_equality WorkSystem::WorkBox, subject.class
  end

end
