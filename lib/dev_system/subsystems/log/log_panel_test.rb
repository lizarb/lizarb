class DevSystem::LogPanelTest < Liza::PanelTest

  test :subject_class do
    assert_equality subject_class, DevSystem::LogPanel
  end

  test_methods_defined do
    on_self
    on_instance \
      :call,
      :find,
      :handler, :handler_keys, :handlers,
      :method_name_for,
      :parse,
      :sidebar_size
  end

  test :call, :unit_log_level, :higher do
    handler_env = nil

    assert_equality subject.handlers, {}
    subject.handlers[:test] = -> env { handler_env = env }

    input_env = {
      object_class: Object,
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
      object_class: Object,
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
      object_class: Object,
      caller: caller,
      unit_log_level: 4,
      message_log_level: 3
    }
    subject.call input_env

    # it has passed the filter
    assert_equality handler_env.object_id, input_env.object_id
  end

  test :handler do
    todo "write this"
  end

  test :handlers do
    todo "write this"
  end

  test :method_name_for do
    view = :kaller_ruby_3_3
    view = :kaller_ruby_3_4 if Lizarb.ruby_version >= "3.4"
    string = render view, format: :txt
    kaller = string.split "\n"

    actual = kaller.map do |line|
      subject.method_name_for caller: [line]
    rescue => e
      "#{e.class}: #{e.message}"
    end

    expected = [
      "eval",
      "call_eval",
      "public_send",
      "call",
      "call",
      "forward",
      "call",
      "forward",
      "call",
      "<top (required)>",
      "load",
      "<top (required)>",
      "load",
      "<main>",
    ]

    assert_equality expected, actual
  end

  test :sidebar_size do
    todo "write this"
  end

end

__END__

# NOTE: views were generated with `liza s:e puts caller`

# view kaller_ruby_3_3.txt.erb
/home/rubyist/lizarb/lib/dev_system/subsystems/shell/commands/shell_command.rb:106:in `eval'
/home/rubyist/lizarb/lib/dev_system/subsystems/shell/commands/shell_command.rb:106:in `call_eval'
/home/rubyist/lizarb/lib/dev_system/subsystems/command/commands/base_command.rb:21:in `public_send'
/home/rubyist/lizarb/lib/dev_system/subsystems/command/commands/base_command.rb:21:in `call'
/home/rubyist/lizarb/lib/dev_system/subsystems/command/commands/base_command.rb:8:in `call'
/home/rubyist/lizarb/lib/dev_system/subsystems/command/parts/command_shortcut_part.rb:54:in `forward'
/home/rubyist/lizarb/lib/dev_system/subsystems/command/command_panel.rb:14:in `call'
/home/rubyist/lizarb/lib/liza/systemic_units/box.rb:66:in `block in forward'
/home/rubyist/lizarb/lib/app.rb:25:in `call'
/home/rubyist/lizarb/exe/lizarb:6:in `<top (required)>'
/home/rubyist/.asdf/installs/ruby/3.3.5/lib/ruby/gems/3.3.0/gems/lizarb-1.0.5/exe/liza:5:in `load'
/home/rubyist/.asdf/installs/ruby/3.3.5/lib/ruby/gems/3.3.0/gems/lizarb-1.0.5/exe/liza:5:in `<top (required)>'
/home/rubyist/.asdf/installs/ruby/3.3.5/bin/liza:25:in `load'
/home/rubyist/.asdf/installs/ruby/3.3.5/bin/liza:25:in `<main>'

# view kaller_ruby_3_4.txt.erb
/home/rubyist/lizarb/lib/dev_system/subsystems/shell/commands/shell_command.rb:106:in 'Kernel#eval'
/home/rubyist/lizarb/lib/dev_system/subsystems/shell/commands/shell_command.rb:106:in 'DevSystem::ShellCommand#call_eval'
/home/rubyist/lizarb/lib/dev_system/subsystems/command/commands/base_command.rb:21:in 'Kernel#public_send'
/home/rubyist/lizarb/lib/dev_system/subsystems/command/commands/base_command.rb:21:in 'DevSystem::BaseCommand#call'
/home/rubyist/lizarb/lib/dev_system/subsystems/command/commands/base_command.rb:8:in 'DevSystem::BaseCommand.call'
/home/rubyist/lizarb/lib/dev_system/subsystems/command/parts/command_shortcut_part.rb:54:in 'DevSystem::CommandPanel#forward'
/home/rubyist/lizarb/lib/dev_system/subsystems/command/command_panel.rb:14:in 'DevSystem::CommandPanel#call'
/home/rubyist/lizarb/lib/liza/systemic_units/box.rb:66:in 'block in DevSystem::DevBox.forward'
/home/rubyist/lizarb/lib/app.rb:25:in 'App.call'
/home/rubyist/lizarb/exe/lizarb:6:in '<top (required)>'
/home/rubyist/.asdf/installs/ruby/3.4.1/lib/ruby/gems/3.4.0/gems/lizarb-1.0.5/exe/liza:5:in 'Kernel#load'
/home/rubyist/.asdf/installs/ruby/3.4.1/lib/ruby/gems/3.4.0/gems/lizarb-1.0.5/exe/liza:5:in '<top (required)>'
/home/rubyist/.asdf/installs/ruby/3.4.1/bin/liza:25:in 'Kernel#load'
/home/rubyist/.asdf/installs/ruby/3.4.1/bin/liza:25:in '<main>'
