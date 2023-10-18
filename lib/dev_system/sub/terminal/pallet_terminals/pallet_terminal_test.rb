class DevSystem::PalletTerminalTest < DevSystem::TerminalTest

  test :subject_class do
    assert subject_class == DevSystem::PalletTerminal
  end

  test :settings do
    assert_equality subject_class.log_level, 0

    assert_equality subject_class.token, :pallet
    assert_equality subject_class.singular, :pallet_terminal
    assert_equality subject_class.plural, :pallet_terminals

    assert_equality subject_class.system, DevSystem
    assert_equality subject_class.subsystem, DevSystem::Terminal
    assert_equality subject_class.division, DevSystem::PalletTerminal
  end

end
