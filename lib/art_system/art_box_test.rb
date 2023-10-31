class ArtSystem::ArtBoxTest < Liza::BoxTest
  
  test :subject_class, :subject do
    assert_equality ArtSystem::ArtBox, subject_class
    assert_equality ArtSystem::ArtBox, subject.class
  end

end
