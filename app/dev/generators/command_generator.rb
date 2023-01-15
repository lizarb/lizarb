class CommandGenerator < Liza::Generator
  main_dsl

  FOLDER = "app/dev/commands"

  generate :controller do
    folder FOLDER
    filename "#{name}_command.rb"
    content render "command.rb"
  end

  generate :controller_test do
    folder FOLDER
    filename "#{name}_command_test.rb"
    content render "command_test.rb"
  end

end
