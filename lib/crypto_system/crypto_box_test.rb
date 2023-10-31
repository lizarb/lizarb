class CryptoSystem::CryptoBoxTest < Liza::BoxTest
  
  test :subject_class, :subject do
    assert_equality CryptoSystem::CryptoBox, subject_class
    assert_equality CryptoSystem::CryptoBox, subject.class
  end

end
