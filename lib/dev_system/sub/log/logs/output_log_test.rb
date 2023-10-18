class DevSystem::OutputLogTest < DevSystem::LogTest

  test :subject_class do
    assert subject_class == DevSystem::OutputLog
  end

  test_methods_defined do
    on_self :call, :sidebar_for
    on_instance
  end

  test :settings do
    assert_equality subject_class.log_level, 0
  end
  
  test :sidebar_for do
    assert_equality "\e[1m\e[38;2;0;255;0mDevSystem\e[0m::\e[38;2;0;255;0mCommand\e[0m:call                                    ",
      sidebar_for(
        DevSystem::Command,
        DevSystem::Command,
        "call"
      )
    assert_equality "\e[1m\e[38;2;0;255;0mDevSystem\e[0m::\e[38;2;0;255;0mTestCommand\e[0m:call                                ",
      sidebar_for(
        DevSystem::TestCommand,
        DevSystem::TestCommand,
        "call"
      )
    assert_equality "\e[38;2;0;255;0mDevBox\e[0m[:command].call                                      ",
      sidebar_for(
        DevSystem::CommandPanel,
        DevSystem::CommandPanel.new(:command),
        "call"
      )
  end

  def sidebar_for unit_class, unit, method_name
    env = {
      unit_class: unit_class,
      unit: unit,
      method_name: method_name
    }
    #
    subject_class.sidebar_for env
  end

end