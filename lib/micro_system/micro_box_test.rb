class MicroSystem::MicroBoxTest < Liza::BoxTest
  
  test :subject_class, :subject do
    assert_equality MicroSystem::MicroBox, subject_class
    assert_equality MicroSystem::MicroBox, subject.class
  end

end
