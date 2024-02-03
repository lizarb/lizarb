class DevSystem::LogPanelTest < Liza::PanelTest

  test :subject_class do
    assert_equality subject_class, DevSystem::LogPanel
  end

  test_methods_defined do
    on_self
    on_instance :call, :handler, :handlers, :method_name_for
  end

  test :call, :unit_log_level, :higher do
    handler_env = nil

    assert_equality subject.handlers, {}
    subject.handlers[:test] = -> env { handler_env = env }

    input_env = {
      caller: caller,
      unit_log_level: 4,
      message_log_level: 5
    }
    subject.call input_env

    # it has not passed the filter
    assert_equality handler_env, nil
  end

  test :call, :unit_log_level do
    handler_env = nil

    assert_equality subject.handlers, {}
    subject.handlers[:test] = -> env { handler_env = env }

    input_env = {
      caller: caller,
      unit_log_level: 4,
      message_log_level: 4
    }
    subject.call input_env

    # it has passed the filter
    assert_equality handler_env.object_id, input_env.object_id
  end

  test :call, :unit_log_level, :lower do
    handler_env = nil

    assert_equality subject.handlers, {}
    subject.handlers[:test] = -> env { handler_env = env }

    input_env = {
      caller: caller,
      unit_log_level: 4,
      message_log_level: 3
    }
    subject.call input_env

    # it has passed the filter
    assert_equality handler_env.object_id, input_env.object_id
  end

end
