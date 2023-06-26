class DevSystem::GeneratorGenerator < Liza::Generator
  main_dsl

  FOLDER = "app/dev/generators"

  generate :controller do
    folder FOLDER
    filename "#{name}_generator.rb"
    content render_controller "generator.rb"
  end

  generate :controller_test do
    folder FOLDER
    filename "#{name}_generator_test.rb"
    content render_controller "generator_test.rb"
  end

  generate :template do
    folder "#{FOLDER}/#{name}_generator"
    filename "#{name}.rb.erb"
    content render_controller "template.rb"
  end

  generate :template_test do
    folder "#{FOLDER}/#{name}_generator"
    filename "#{name}_test.rb.erb"
    content render_controller "template_test.rb"
  end

end
