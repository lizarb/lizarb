class DevSystem::NotFoundGeneratorTest < DevSystem::SimpleGeneratorTest

  test :subject_class, :subject do
    assert_equality subject_class, DevSystem::NotFoundGenerator
    assert_equality subject.class, DevSystem::NotFoundGenerator
  end

  test :call_default do
    assert_raises NoMethodError do
      subject.call_default
    end
    assert_no_raise do
      subject.menv = {}
      subject.call_default
    end
  end

end
