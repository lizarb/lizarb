class BashAdapterShellTest < DevSystem::ShellTest

  test :subject_class do
    assert_equality subject_class, BashAdapterShell
  end

  test :query_something do
    a = subject_class.query_something "some args"
    b = "9\n"
    assert_equality a, b
  end

  test :execute_something do
    a = subject_class.execute_something "same args"
    b = true
    assert_equality a, b
  end

end
