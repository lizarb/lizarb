class Liza::PartTest < Liza::UnitTest
  test :subject_class do
    assert subject_class == Liza::Part
  end

  test_methods_defined do
    on_self :extension, :insertion
    on_instance
  end

end
