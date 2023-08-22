class SortedBenchTest < Liza::BenchTest

  test :subject_class do
    assert_equality subject_class, SortedBench
  end

  test :settings do
    assert_equality subject_class.log_level, :normal
    assert_equality subject_class.log_color, :green
  end

end
