class DevSystem::CommandPanelTest < Liza::PanelTest

  test :subject_class do
    assert_equality subject_class, DevSystem::CommandPanel
  end

  test_methods_defined do
    on_self
    on_instance \
      :build_env,
      :call, :call_not_found,
      :find,
      :forward,
      :input,
      :parse,
      :pick_many, :pick_one
  end

  test :parse do
    assert_equality \
      (subject.parse "generate"),
      {:command_given=>"generate", :command_action=>nil, :command_arg=>"generate"}

    assert_equality \
      (subject.parse "generate:install"),
      {:command_given=>"generate", :command_action=>"install", :command_arg=>"generate:install"}

    assert_equality \
      (subject.parse "two_words"),
      {:command_given=>"two_words", :command_action=>nil, :command_arg=>"two_words"}

    assert_equality \
      (subject.parse "word10"),
      {:command_given=>"word10", :command_action=>nil, :command_arg=>"word10"}
  end

  test :find do
    klass = subject._find "generate"
    assert_equality DevSystem::GenerateCommand, klass

    begin
      klass = subject._find "g"
      assert false
    rescue CommandPanel::NotFoundError
      assert true
    end
  end

end
