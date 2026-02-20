class Liza::ControllerTest < Liza::UnitTest
  test :subject_class do
    assert subject_class == Liza::Controller
  end

  test_sections(
    :subsystem=>{
      :constants=>[],
      :class_methods=>[:inherited, :color, :sh, :`, :subsystem, :subsystem?, :subsystem!, :box, :panel],
      :instance_methods=>[:sh, :`, :box, :panel]
    },
    :divisionable=>{
      :constants=>[],
      :class_methods=>[:division, :division?, :division!],
      :instance_methods=>[]
    },
    :grammarable=>{
      :constants=>[],
      :class_methods=>[:singular, :plural],
      :instance_methods=>[]
    },
    :identifiable=>{
      :constants=>[],
      :class_methods=>[:token, :subsystem_token, :division_token],
      :instance_methods=>[:id]
    },
    :fileable=>{
      :constants=>[],
      :class_methods=>[:fileable_name, :subsystem_directory, :temporary_directory, :data_directory, :permanent_directory],
      :instance_methods=>[:temporary_directory, :data_directory, :permanent_directory]
    },
    :callable=>{
      :constants=>[],
      :class_methods=>[:call],
      :instance_methods=>[:call]
    },
    :requirable=>{
      :constants=>[],
      :class_methods=>[:require, :requirements],
      :instance_methods=>[]
    },
    :attributable=>{
      :constants=>[],
      :class_methods=>[:attr_reader, :attr_writer, :attr_accessor],
      :instance_methods=>[:attrs]
    },
    :environmentable=>{
      :constants=>[:Env],
      :class_methods=>[:menv_reader, :menv_writer, :menv_accessor, :env],
      :instance_methods=>[:menv, :menv=, :env]
    },
    :default=>{
      # this is because tests mock this class
      :constants=>[],
      :class_methods=>[:log, :puts],
      :instance_methods=>[:log, :puts]
    }
  )

  test :erbs_defined do
    erbs_defined = subject_class.erbs_defined.map(&:key)
    expected = []
    assert_equality erbs_defined, expected
  end

  test :erbs_available do
    erbs_available = subject_class.erbs_available.map(&:key)
    expected = []
    assert_equality erbs_available, expected
  end

  test :fileable, :subsystem_directory do
    assert_equality Shell.subsystem_directory,         (App.root / "lib/dev_system/subsystems/shell")
    assert_equality RubyShell.subsystem_directory,     (App.root / "lib/dev_system/subsystems/shell")
    assert_equality HashRubyShell.subsystem_directory, (App.root / "lib/dev_system/subsystems/shell")
  end

  test :fileable, :dev_system do
    assert_equality Shell.data_directory.to_s,      "#{App.root}/dat/coding_matrix/dev_system_shells/shell"
    assert_equality Shell.permanent_directory.to_s, "#{App.root}/prm/matrix/dev_system_shells/shell"
    assert_equality Shell.temporary_directory.to_s, "#{App.root}/tmp/coding_matrix/dev_system_shells/shell"

    assert_equality RubyShell.data_directory.to_s,      "#{App.root}/dat/coding_matrix/dev_system_shells/ruby_shell"
    assert_equality RubyShell.permanent_directory.to_s, "#{App.root}/prm/matrix/dev_system_shells/ruby_shell"
    assert_equality RubyShell.temporary_directory.to_s, "#{App.root}/tmp/coding_matrix/dev_system_shells/ruby_shell"

    assert_equality HashRubyShell.data_directory.to_s,      "#{App.root}/dat/coding_matrix/dev_system_shells/hash_ruby_shell"
    assert_equality HashRubyShell.permanent_directory.to_s, "#{App.root}/prm/matrix/dev_system_shells/hash_ruby_shell"
    assert_equality HashRubyShell.temporary_directory.to_s, "#{App.root}/tmp/coding_matrix/dev_system_shells/hash_ruby_shell"
  end

  test :fileable, :happy_system do
    assert_equality AxoCommand.data_directory.to_s,      "#{App.root}/dat/coding_matrix/happy_system_commands/axo_command"
    assert_equality AxoCommand.permanent_directory.to_s, "#{App.root}/prm/matrix/happy_system_commands/axo_command"
    assert_equality AxoCommand.temporary_directory.to_s, "#{App.root}/tmp/coding_matrix/happy_system_commands/axo_command"

    assert_equality Axo.data_directory.to_s,      "#{App.root}/dat/coding_matrix/happy_system_axos/axo"
    assert_equality Axo.permanent_directory.to_s, "#{App.root}/prm/matrix/happy_system_axos/axo"
    assert_equality Axo.temporary_directory_pathname.to_s, "#{App.root}/tmp/coding_matrix/happy_system_axos/axo"

    axo = Axo.new
    def axo.to_id () = ("1234")

    assert_equality axo.data_directory_pathname.to_s,      "#{App.root}/dat/coding_matrix/happy_system_axos/axo/1234"
    assert_equality axo.permanent_directory_pathname.to_s, "#{App.root}/prm/matrix/happy_system_axos/axo/1234"
    assert_equality axo.temporary_directory_pathname.to_s, "#{App.root}/tmp/coding_matrix/happy_system_axos/axo/1234"
  end if defined? HappySystem

end
