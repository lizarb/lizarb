class PokeapiClientTest < NetSystem::HttpClientTest

  section :test

  test :subject_class, :subject do
    assert_equality subject_class, PokeapiClient
    assert_equality subject.class, PokeapiClient
  end

end
