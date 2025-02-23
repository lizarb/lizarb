class DevSystem::ColorShellTest < DevSystem::ShellTest
  
  # 

  test :subject_class, :subject do
    assert_equality DevSystem::ColorShell, subject_class
    assert_equality DevSystem::ColorShell, subject.class
  end

  test :subject_class, :rgb_from_int do
    assert_equality [255, 255, 255], subject_class.rgb_from_int(0xffffff)
    assert_equality [0, 0, 0], subject_class.rgb_from_int(0x000000)
    assert_equality [255, 0, 0], subject_class.rgb_from_int(0xff0000)
  end

  test :subject_class, :rgb_from_str do
    assert_equality [255, 255, 255], subject_class.rgb_from_str("#ffffff")
    assert_equality [0, 0, 0], subject_class.rgb_from_str("#000000")
    assert_equality [255, 0, 0], subject_class.rgb_from_str("#ff0000")
  end

end
