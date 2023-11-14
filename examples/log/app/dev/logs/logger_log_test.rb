class LoggerLogTest < DevSystem::LogTest

  test :subject_class do
    assert subject_class == LoggerLog
  end

  test_methods_defined do
    on_self :call
    on_instance
  end

  test :settings do
    assert_equality subject_class.log_level, 0
  end
  
end
