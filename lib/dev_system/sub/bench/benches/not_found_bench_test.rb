class DevSystem::NotFoundBenchTest < DevSystem::BenchTest

  test :subject_class do
      assert subject_class == DevSystem::NotFoundBench
    end

    test :settings do
      assert_equality subject_class.log_level, 0
    end

end
