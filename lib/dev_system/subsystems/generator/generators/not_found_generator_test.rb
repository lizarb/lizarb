class DevSystem::NotFoundGeneratorTest < DevSystem::SimpleGeneratorTest

  test :subject_class, :subject do
    assert_equality subject_class, DevSystem::NotFoundGenerator
    assert_equality subject.class, DevSystem::NotFoundGenerator
  end

  test :call_default do
    assert_no_raise do
      subject.call_default
    end
  end

end
