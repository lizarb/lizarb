class BusinessLogicShellTest < DevSystem::ShellTest

  test :subject_class do
    assert_equality subject_class, BusinessLogicShell
  end

  test :settings do
    assert_equality subject_class.log_level, 0
  end

  #

  test :metric_bmi do
    a = subject_class.metric_bmi 100, 193
    b = 26.85
    assert_equality a.round(2), b
  end

  test :imperial_bmi do
    a = subject_class.imperial_bmi 222, 76
    b = 26.81
    assert_equality a.round(2), b
  end

  #

  test :pounds_to_kilograms do
    a = subject_class.pounds_to_kilograms 222
    b = 100
    assert_equality a.round(0), b
  end

  test :inches_to_centimeters do
    a = subject_class.inches_to_centimeters 76
    b = 193
    assert_equality a.round(0), b
  end

end
