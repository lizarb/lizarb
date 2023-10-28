class LabSystem::LabBoxTest < Liza::BoxTest
  
  test :subject_class, :subject do
    assert_equality LabSystem::LabBox, subject_class
    assert_equality LabSystem::LabBox, subject.class
  end

end
