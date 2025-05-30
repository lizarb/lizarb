class DevSystem::SignalShellTest < DevSystem::ShellTest

  section :subject

  test :subject_class, :subject do
    assert_equality subject_class, DevSystem::SignalShell
    assert_equality subject.class, DevSystem::SignalShell
  end

  test :list do
    assert_equality subject_class.list, expected_linux_list if Shell.linux?
    assert_equality subject_class.list, expected_mac_list if Shell.mac?
    assert_equality subject_class.list, expected_windows_list if Shell.windows?
  end

  def expected_linux_list
    {"EXIT"=>0, "HUP"=>1, "INT"=>2, "QUIT"=>3, "ILL"=>4, "TRAP"=>5, "ABRT"=>6, "IOT"=>6, "BUS"=>7, "FPE"=>8, "KILL"=>9, "USR1"=>10, "SEGV"=>11, "USR2"=>12, "PIPE"=>13, "ALRM"=>14, "TERM"=>15, "CLD"=>17, "CHLD"=>17, "CONT"=>18, "STOP"=>19, "TSTP"=>20, "TTIN"=>21, "TTOU"=>22, "URG"=>23, "XCPU"=>24, "XFSZ"=>25, "VTALRM"=>26, "PROF"=>27, "WINCH"=>28, "IO"=>29, "POLL"=>29, "PWR"=>30, "SYS"=>31}
  end

  def expected_mac_list
    {"EXIT"=>0, "HUP"=>1, "INT"=>2, "QUIT"=>3, "ILL"=>4, "TRAP"=>5, "ABRT"=>6, "IOT"=>6, "EMT"=>7, "FPE"=>8, "KILL"=>9, "BUS"=>10, "SEGV"=>11, "SYS"=>12, "PIPE"=>13, "ALRM"=>14, "TERM"=>15, "URG"=>16, "STOP"=>17, "TSTP"=>18, "CONT"=>19, "CHLD"=>20, "CLD"=>20, "TTIN"=>21, "TTOU"=>22, "IO"=>23, "XCPU"=>24, "XFSZ"=>25, "VTALRM"=>26, "PROF"=>27, "WINCH"=>28, "INFO"=>29, "USR1"=>30, "USR2"=>31}
  end

  def expected_windows_list
    {"EXIT"=>0, "INT"=>2, "ILL"=>4, "FPE"=>8, "KILL"=>9, "SEGV"=>11, "TERM"=>15, "ABRT"=>22}
  end

end
