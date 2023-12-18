class Liza::TimeTest < Liza::ObjectTest
  
  test :subject_class do
    assert_equality subject_class, Time
  end
  
  test :diff do
    assert_equality "0.0", Time.now.diff(1)
    assert_equality "0.00", Time.now.diff(2)

    assert_raises(ArgumentError) { Time.now.diff(0) }
    assert_equality (2+1), Time.now.diff(1).size
    assert_equality (2+2), Time.now.diff(2).size
    assert_equality (2+3), Time.now.diff(3).size
    assert_equality (2+4), Time.now.diff(4).size
    assert_raises(ArgumentError) { Time.now.diff(5) }
  end

end
