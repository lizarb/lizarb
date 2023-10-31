class FooRequestTest < WebSystem::SimpleRequestTest

  test :subject_class do
    assert_equality subject_class, FooRequest
  end

end
