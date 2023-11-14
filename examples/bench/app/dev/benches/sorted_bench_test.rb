class SortedBenchTest < DevSystem::BenchTest

  test :subject_class do
    assert_equality subject_class, SortedBench
  end

  test :settings do
    assert_equality subject_class.log_level, 0
  end

end
