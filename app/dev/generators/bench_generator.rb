class BenchGenerator < Liza::Generator
  main_dsl

  FOLDER = "app/dev/benches"

  generate :controller do
    folder FOLDER
    filename "#{name}_bench.rb"
    content bench_content
  end

  generate :controller_test do
    folder FOLDER
    filename "#{name}_bench_test.rb"
    content bench_test_content
  end

  # helper methods

  def bench_content
    <<~CODE
class #{name.camelize}Bench < AppBench

  main_dsl

  setup do
    N = 1_000_000
  end

  mark "alternative 1" do
    i = 0

    while (i += 1) <= N
      a = "1".to_sym
    end
  end

  mark "alternative 2" do
    i = 0

    while (i += 1) <= N
      a = :"1"
    end
  end

end
    CODE
  end

  def bench_test_content
    <<~CODE
class #{name.camelize}BenchTest < Liza::BenchTest

  test :subject_class do
    assert subject_class == #{name.camelize}Bench
  end

  test :settings do
    assert subject_class.log_level == :normal
    assert subject_class.log_color == :green
  end

end
    CODE
  end

end
