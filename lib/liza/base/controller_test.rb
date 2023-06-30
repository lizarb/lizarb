class Liza::ControllerTest < Liza::UnitTest
  test :subject_class do
    assert subject_class == Liza::Controller
  end

  test :settings do
    assert subject_class.log_level == :normal
    assert subject_class.log_color == :white
  end

  test :defined_erbs do
    defined_erbs = subject_class.defined_erbs.map(&:key)
    expected = []
    assert_equality defined_erbs, expected
  end

  test :available_erbs do
    available_erbs = subject_class.available_erbs.map(&:key)
    expected = []
    assert_equality available_erbs, expected
  end

end
