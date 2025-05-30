class PrimeSystem::KrokiClientTest < NetSystem::ClientTest

  section :test

  test :subject_class, :subject do
    assert_equality subject_class, PrimeSystem::KrokiClient
    assert_equality subject.class, PrimeSystem::KrokiClient
  end

end
