class LabSystem::KrokiRequestTest < WebSystem::SimpleRequestTest

  test :subject_class do
    assert_equality subject_class, LabSystem::KrokiRequest
  end

  test :settings do
    assert_equality subject_class.log_level, 0
  end

end  