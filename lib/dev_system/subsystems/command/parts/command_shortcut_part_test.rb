class DevSystem::CommandShortcutPartTest < Liza::PartTest

  test :subject_class do
    assert_equality subject_class, DevSystem::CommandShortcutPart
  end
end