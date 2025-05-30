class DevSystem::SoftShellTest < DevSystem::ShellTest

  section :subject

  test :subject_class, :subject do
    assert_equality subject_class, DevSystem::SoftShell
    assert_equality subject.class, DevSystem::SoftShell
  end

  test :subject_class, :standardize_path do
    assert_equality subject_class.standardize_path("exe/liza"), App.root.join("exe/liza").to_s
    assert_equality subject_class.standardize_path("bin/does_not_exist"), App.root.join("bin/does_not_exist").to_s
    assert_equality subject_class.standardize_path("./bin/does_not_exist"), "./bin/does_not_exist"
    assert_equality subject_class.standardize_path("/usr/bin/bash"), "/usr/bin/bash"
  end

end
