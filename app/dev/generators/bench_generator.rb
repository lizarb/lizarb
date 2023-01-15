class BenchGenerator < Liza::Generator
  main_dsl

  FOLDER = "app/dev/benches"

  generate :controller do
    folder FOLDER
    filename "#{name}_bench.rb"
    content render "bench.rb"
  end

  generate :controller_test do
    folder FOLDER
    filename "#{name}_bench_test.rb"
    content render "bench_test.rb"
  end

end
