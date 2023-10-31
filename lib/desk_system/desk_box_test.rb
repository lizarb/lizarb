class DeskSystem::DeskBoxTest < Liza::BoxTest
  
  test :subject_class, :subject do
    assert_equality DeskSystem::DeskBox, subject_class
    assert_equality DeskSystem::DeskBox, subject.class
  end

end
