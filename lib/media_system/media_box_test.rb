class MediaSystem::MediaBoxTest < Liza::BoxTest
  
  # 

  test :subject_class, :subject do
    assert_equality MediaSystem::MediaBox, subject_class
    assert_equality MediaSystem::MediaBox, subject.class
  end
  
end
