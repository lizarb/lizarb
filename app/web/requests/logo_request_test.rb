class LogoRequestTest < WebSystem::SimpleRequestTest

  section :test

  test :subject_class, :subject do
    assert_equality subject_class, LogoRequest
    assert_equality subject.class, LogoRequest
  end

end
