class Liza::UnitRenderingPartTest < Liza::UnitTest

  test :erbs_defined do
    erbs_defined = Unit.erbs_defined.map(&:key)
    expected = ["render.txt.erb"]
    assert_equality erbs_defined, expected
  end

  test :erbs_available do
    erbs_available = Unit.erbs_available.map(&:key)
    expected = []
    assert_equality erbs_available, expected
  end

end
