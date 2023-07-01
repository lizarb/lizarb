class DevSystem::NotFoundBenchTest < DevSystem::BenchTest

  test :subject_class do
      assert subject_class == DevSystem::NotFoundBench
    end

    test :settings do
      assert subject_class.log_level == :normal
      assert subject_class.log_color == :green
    end

end
