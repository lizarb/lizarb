class MyNiceSystem::MyNiceSystemTest < Liza::SystemTest

  section :systemic

  test :subject_class do
    assert_equality subject_class, MyNiceSystem::MyNiceSystem
  end

end
