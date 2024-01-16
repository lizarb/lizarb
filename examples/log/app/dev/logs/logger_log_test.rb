class LoggerLogTest < DevSystem::LogTest

  test :subject_class do
    assert subject_class == LoggerLog
  end

  test_methods_defined do
    on_self :call
    on_instance
  end
  
end
