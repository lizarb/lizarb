class DevSystem::ColorOutputHandlerLogTest < DevSystem::OutputHandlerLogTest
  
  # 

  test :subject_class, :subject do
    assert_equality DevSystem::ColorOutputHandlerLog, subject_class
    assert_equality DevSystem::ColorOutputHandlerLog, subject.class
  end
  
  test :sidebar_for do
    assert_equality "\e[1m\e[38;2;0;204;0mDevSystem\e[0m::\e[1m\e[38;2;0;204;0mCommand\e[0m:call                                    ",
      sidebar_for(
        DevSystem::Command,
        DevSystem::Command,
        "call"
      )
    assert_equality "\e[1m\e[38;2;0;204;0mDevSystem\e[0m::\e[1m\e[38;2;0;204;0mTestCommand\e[0m:call                                ",
      sidebar_for(
        DevSystem::TestCommand,
        DevSystem::TestCommand,
        "call"
      )
    assert_equality "\e[1m\e[38;2;0;204;0mDevSystem\e[0m::\e[1m\e[38;2;0;204;0mCommand\e[0m.panel.call                              ",
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
