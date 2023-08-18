class DevSystem::LogPanelTest < Liza::PanelTest

  test :subject_class do
    assert subject_class == DevSystem::LogPanel
  end

  test_methods_defined do
    on_self
    on_instance :call, :method_name_for, :sidebar_for
  end

  test :settings do
    assert subject_class.log_level == :normal
    assert subject_class.log_color == :green
  end

  # test :call do
  #   todo "write this"
  # end

  test :sidebar_for do
    assert_equality "DevSystem::Command:call                                    ",
      sidebar_for(
        DevSystem::Command,
        DevSystem::Command,
        "call"
      )
    assert_equality "DevSystem::TestCommand:call                                ",
      sidebar_for(
        DevSystem::TestCommand,
        DevSystem::TestCommand,
        "call"
      )
    assert_equality "DevSystem::DevBox[:command].call                           ",
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
    s = subject.sidebar_for env
    s.uncolorize
  end


end
