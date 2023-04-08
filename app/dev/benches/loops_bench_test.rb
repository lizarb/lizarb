class LoopsBenchTest < Liza::BenchTest

  test :subject_class do
    assert subject_class == LoopsBench
  end

  test :marks do
    assert subject_class.marks.keys.count.positive?
  end

end
