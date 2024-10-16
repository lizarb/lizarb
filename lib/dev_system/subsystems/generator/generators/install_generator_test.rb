class DevSystem::InstallGeneratorTest < DevSystem::SimpleGeneratorTest
  
  test :subject_class, :subject do
    assert_equality DevSystem::InstallGenerator, subject_class
    assert_equality DevSystem::InstallGenerator, subject.class
  end
  
end
