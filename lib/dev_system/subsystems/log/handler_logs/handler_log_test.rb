class DevSystem::HandlerLogTest < DevSystem::LogTest

  test :subject_class do
    assert subject_class == DevSystem::HandlerLog
  end

  test_methods_defined do
    on_self
    on_instance
  end

end