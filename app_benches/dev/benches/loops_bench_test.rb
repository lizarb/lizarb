class LoopsBenchTest < SortedBenchTest

  test :subject_class do
    assert subject_class == LoopsBench
  end

  test :settings do
    assert subject_class.log_level == :normal
    assert subject_class.log_color == :green
  end

end
