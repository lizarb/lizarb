class NetSystem::HttpClientTest < NetSystem::ClientTest

  section :test

  test :subject_class, :subject do
    assert_equality subject_class, NetSystem::HttpClient
    assert_equality subject.class, NetSystem::HttpClient
  end

end
