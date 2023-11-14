class GemAdapterShellTest < DevSystem::ShellTest

  test :subject_class do
    assert_equality subject_class, GemAdapterShell
  end

  test :settings do
    assert_equality subject_class.log_level, 0
  end

  test :do_something do
    a = subject_class.do_something "some args"
    b = [:some, :result]
    assert_equality a, b
  end

  test :do_something_else do
    a = subject_class.do_something_else "same args"
    b = {some: {other: :result}}
    assert_equality a, b
  end

end
