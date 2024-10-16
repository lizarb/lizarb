class DevSystem::UninstallGeneratorTest < DevSystem::SimpleGeneratorTest
  
  test :subject_class, :subject do
    assert_equality DevSystem::UninstallGenerator, subject_class
    assert_equality DevSystem::UninstallGenerator, subject.class
  end
  
end
