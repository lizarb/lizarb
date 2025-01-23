class Liza::LizaTest < Liza::ObjectTest
  
  test :subject_class do
    assert_equality subject_class, Liza
  end

end
